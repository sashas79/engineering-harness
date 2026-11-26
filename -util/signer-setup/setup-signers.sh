#!/usr/bin/env bash
# Build and run signer key-generation and enrolment scripts from convention rows.
# Bash 3.2+ and Python 3.8+. Run key/enrolment steps in an operator terminal.
set -euo pipefail
command -v python3 >/dev/null 2>&1 || { echo 'python3 is required.' >&2; exit 1; }
# Keep the operator's stdin: Python reads its program from the heredoc, but
# ssh-keygen and enrolment confirmations must read the original terminal.
exec python3 - "$@" 3<&0 <<'PYTHON'
import argparse
import csv
import io
import os
import re
import shlex
import shutil
import sys
from pathlib import Path

SAMPLE = '''signer,identity,private_key,public_key,mode,authorities
Sasha,sasha,~/.ssh/jev-router-sasha,Sasha.pub,anchor,product_domain
Chris,chris,~/.ssh/jev-router-chris,chris.pub,member,architecture
Wayne,wayne,~/.ssh/jev-router-wayne,wayne.pub,member,security_platform
Petre,petre,~/.ssh/jev-router-petre,petre.pub,member,engineering;release
'''

KEY_SCRIPT = r'''#!/usr/bin/env bash
# Generated helper. All keys are created on this machine, as requested.
set -euo pipefail
umask 077
[[ $# -eq 3 ]] || { echo "Usage: bash $0 <identity> <private-key-path> <public-export-path>" >&2; exit 64; }
identity=$1
key=$2
exported=$3
[[ -t 0 && -t 1 ]] || { echo 'Run from an interactive operator terminal.' >&2; exit 1; }
command -v ssh-keygen >/dev/null || { echo 'ssh-keygen is required.' >&2; exit 1; }
for path in "$key" "$key.pub" "$exported"; do
  if [[ -e "$path" || -L "$path" ]]; then
    printf 'Refusing to overwrite existing file: %s\n' "$path" >&2
    exit 1
  fi
done
mkdir -p "$(dirname "$key")" "$(dirname "$exported")"
printf '\nCreating key for %s on this machine. Use a strong passphrase when prompted.\n' "$identity"
ssh-keygen -t ed25519 -f "$key" -C "$(basename "$key")"
chmod 600 "$key" "$key.pub"
( set -o noclobber; cat "$key.pub" > "$exported" )
printf '\nPrivate key: %s\nPublic export: %s\nFingerprint:\n' "$key" "$exported"
ssh-keygen -lf "$exported"
'''

ENROL_SCRIPT = r'''#!/usr/bin/env bash
# Generated helper. Run by the signer administrator in an operator terminal.
set -euo pipefail
if [[ $# -eq 2 && "$1" == check ]]; then
  cd "$2"
  [[ -x ./harness ]] || { echo 'Missing executable ./harness in the project root.' >&2; exit 1; }
  exec ./harness check_signers --project-root . --pretty
fi
[[ $# -eq 5 ]] || { echo "Usage: bash $0 <anchor|member> <identity> <anchor-private-key> <public-key> <project-root>" >&2; exit 64; }
mode=$1
identity=$2
anchor_key=$3
pub=$4
project_root=$5
case "$mode" in anchor|member) ;; *) echo 'Mode must be anchor or member.' >&2; exit 64 ;; esac
[[ -t 0 && -t 1 ]] || { echo 'Run from an interactive operator terminal.' >&2; exit 1; }
command -v ssh-keygen >/dev/null || { echo 'ssh-keygen is required.' >&2; exit 1; }
cd "$project_root"
[[ -x ./harness ]] || { echo 'Missing executable ./harness in the project root.' >&2; exit 1; }
[[ -f "$anchor_key" && -f "$anchor_key.pub" ]] || { echo "Missing anchor key pair: $anchor_key" >&2; exit 1; }
[[ -f "$pub" ]] || { echo "Missing public key: $pub" >&2; exit 1; }
check() { ./harness check_signers --project-root . --pretty; }
confirm() {
  local reply
  read -r -p "$1 Type YES to continue: " reply
  [[ "$reply" == YES ]] || { echo 'Stopped by operator.' >&2; exit 1; }
}
check
printf '\nProposed public key for %s: %s\n' "$identity" "$pub"
ssh-keygen -lf "$pub"
if [[ "$mode" == anchor ]]; then
  # Compare fingerprints so an unrelated export cannot be shown as the anchor.
  anchor_fingerprint=$(ssh-keygen -lf "$anchor_key.pub")
  export_fingerprint=$(ssh-keygen -lf "$pub")
  read -r _ anchor_fp _ <<< "$anchor_fingerprint"
  read -r _ export_fp _ <<< "$export_fingerprint"
  [[ "$anchor_fp" == "$export_fp" ]] || { echo 'Anchor export does not match the anchor public key.' >&2; exit 1; }
  confirm "Confirm this project has no signer anchor and $identity is the intended anchor."
  ./harness enrol_signer --project-root . --identity "$identity" --key "$anchor_key"
else
  confirm "Confirm this fingerprint is the intended key for $identity and is not already enrolled."
  ./harness enrol_signer --project-root . --identity "$identity" --key "$anchor_key" --public-key "$pub"
fi
printf '\nSigner chain after enrolling %s:\n' "$identity"
check
'''


def fail(message):
    raise ValueError(message)


def load_rows(text):
    lines = [line for line in text.splitlines() if line.strip()]
    if not lines:
        fail('Input contains no table rows.')
    if lines[0].lstrip().startswith('|'):
        cells = lambda line: [part.strip().strip('`') for part in line.strip().strip('|').split('|')]
        header = cells(lines[0])
        records = []
        for line in lines[1:]:
            if not line.lstrip().startswith('|'):
                fail('Markdown input must contain only a table, without headings or prose.')
            row = cells(line)
            if all(re.fullmatch(r':?-+:?', value) for value in row):
                continue
            records.append(row)
    else:
        reader = csv.reader(io.StringIO(text))
        header = next(reader)
        records = [row for row in reader if any(value.strip() for value in row)]
    header = [re.sub(r'\s+', '_', value.strip().lower()) for value in header]
    required = {'identity', 'private_key', 'public_key', 'mode'}
    permitted = required | {'signer', 'authorities'}
    if len(header) != len(set(header)):
        fail('Duplicate table column names.')
    if not required.issubset(header) or set(header) - permitted:
        fail('Columns must include identity, private_key, public_key, mode; optional: signer, authorities.')
    rows = []
    for number, record in enumerate(records, 2):
        if len(record) != len(header):
            fail('Row {} has {} cells; expected {}.'.format(number, len(record), len(header)))
        row = {key: value.strip() for key, value in zip(header, record)}
        if any(not row[key] for key in required):
            fail('Row {} contains an empty required cell.'.format(number))
        if any(any(ord(ch) < 32 for ch in value) for value in row.values()):
            fail('Row {} contains a control character.'.format(number))
        if not re.fullmatch(r'[a-z][a-z0-9_.-]*', row['identity']):
            fail('Invalid identity {!r}: use lowercase letters, digits, dots, underscores or hyphens.'.format(row['identity']))
        if row['mode'] not in ('anchor', 'member'):
            fail('Mode for {} must be anchor or member.'.format(row['identity']))
        rows.append(row)
    if not rows:
        fail('Input contains no signer rows.')
    if len({row['identity'] for row in rows}) != len(rows):
        fail('Duplicate identities: use one row per signer, even when they hold several authorities.')
    if sum(row['mode'] == 'anchor' for row in rows) != 1:
        fail('The complete input must contain exactly one anchor row.')
    return rows


def expand_path(value, base):
    # Expand only the documented HOME notation, never shell commands or env vars.
    if value.startswith('${HOME}') and (len(value) == 7 or value[7] == '/'):
        value = str(Path.home()) + value[7:]
    elif value.startswith('$HOME') and (len(value) == 5 or value[5] == '/'):
        value = str(Path.home()) + value[5:]
    if '$' in value or (value.startswith('~') and not value.startswith('~/')):
        fail('Use ~/ or $HOME/ for home paths; other variable and user expansions are unsupported: ' + value)
    path = Path(os.path.expanduser(value))
    if not path.is_absolute():
        path = base / path
    return Path(os.path.abspath(str(path)))


def command(*parts):
    return ' '.join(shlex.quote(str(part)) for part in parts)


def write_script(path, content):
    with path.open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(content)
    path.chmod(0o700)


def main():
    parser = argparse.ArgumentParser(
        description='Generate and run key-generation/enrolment scripts from a CSV or Markdown table. '
                    'All selected private keys are generated on this machine. Default input: Sasha, Chris, Wayne and Petre.')
    parser.add_argument('--input', type=Path, help='CSV or Markdown convention table; omit to use built-in sample rows')
    parser.add_argument('--project-root', type=Path, default=Path.cwd(), help='project containing ./harness (default: current directory)')
    parser.add_argument('--output', type=Path, default=Path('signer-setup-generated'), help='new directory for generated scripts; must not exist')
    parser.add_argument('--public-dir', type=Path, help='base for relative public_key paths (default: <output>/public-keys)')
    parser.add_argument('--only', help='comma-separated identities to select from the input; default: every row')
    parser.add_argument('--phase', choices=['all', 'keys', 'enrol'], default='all', help='scripts to run (default: all)')
    parser.add_argument('--generate-only', action='store_true', help='write scripts without generating keys or enrolling signers')
    parser.add_argument('--sample', action='store_true', help='print sample CSV and exit')
    args = parser.parse_args()
    if args.sample:
        print(SAMPLE, end='')
        return
    rows = load_rows(args.input.read_text(encoding='utf-8-sig') if args.input else SAMPLE)
    project = args.project_root.expanduser().absolute().resolve()
    output = args.output.expanduser().absolute()
    public_base = args.public_dir.expanduser().absolute() if args.public_dir else output / 'public-keys'
    if not project.is_dir():
        fail('Project root must be an existing directory: ' + str(project))
    if os.path.lexists(str(output)):
        fail('Output directory already exists; choose a new --output: ' + str(output))
    occupied = {}
    for row in rows:
        row['private_key'] = str(expand_path(row['private_key'], project))
        row['public_key'] = str(expand_path(row['public_key'], public_base))
        if not row['public_key'].endswith('.pub'):
            fail('Public export must end in .pub: ' + row['public_key'])
        for path in (row['private_key'], row['private_key'] + '.pub', row['public_key']):
            canonical = os.path.realpath(path)
            if canonical in occupied:
                fail('Key/export path collision between {} and {}: {}'.format(occupied[canonical], row['identity'], path))
            # Private keys must stay outside the directory of shareable scripts.
            if path == row['private_key'] and os.path.commonpath([canonical, os.path.realpath(str(output))]) == os.path.realpath(str(output)):
                fail('Keep private keys outside --output: ' + path)
            occupied[canonical] = row['identity']
    # A path must not also be a parent of another key/export file.
    for path in occupied:
        if any(str(parent) in occupied for parent in Path(path).parents):
            fail('A key/export file is also used as a directory: ' + path)
    anchor = next(row for row in rows if row['mode'] == 'anchor')
    selected = rows
    if args.only is not None:
        names = [name.strip() for name in args.only.split(',')]
        if not all(names) or len(names) != len(set(names)):
            fail('--only requires distinct, nonempty identities.')
        unknown = set(names) - {row['identity'] for row in rows}
        if unknown:
            fail('Unknown selected identities: ' + ', '.join(sorted(unknown)))
        selected = [row for row in rows if row['identity'] in names]
    # Stable ordering: the anchor is always enrolled first when selected.
    selected = sorted(selected, key=lambda row: row['mode'] != 'anchor')
    if not args.generate_only:
        if not os.isatty(3) or not os.isatty(1):
            fail('Execution requires an interactive operator terminal. Use --generate-only to prepare scripts without one.')
        if not shutil.which('ssh-keygen'):
            fail('ssh-keygen is required.')
        if args.phase != 'keys' and not os.access(str(project / 'harness'), os.X_OK):
            fail('Missing executable ./harness in ' + str(project))
    os.umask(0o077)
    output.mkdir(mode=0o700, parents=True, exist_ok=False)
    key_helper = output / 'generate-signer-key.sh'
    enrol_helper = output / 'enrol-signers.sh'
    write_script(key_helper, KEY_SCRIPT)
    write_script(enrol_helper, ENROL_SCRIPT)
    generates, enrols = [], []
    for index, row in enumerate(selected, 1):
        name = '{:02d}-{}'.format(index, row['identity'])
        generate = output / (name + '-generate.sh')
        enrol = output / (name + '-enrol.sh')
        write_script(generate, '#!/usr/bin/env bash\nset -euo pipefail\nexec ' + command('bash', key_helper, row['identity'], row['private_key'], row['public_key']) + '\n')
        write_script(enrol, '#!/usr/bin/env bash\nset -euo pipefail\nexec ' + command('bash', enrol_helper, row['mode'], row['identity'], anchor['private_key'], row['public_key'], project) + '\n')
        generates.append(generate)
        enrols.append(enrol)
    runner = ['#!/usr/bin/env bash', 'set -euo pipefail', 'umask 077',
              'phase=${1:-all}', '[[ $# -le 1 ]] || { echo "Usage: bash $0 [all|keys|enrol]" >&2; exit 64; }',
              'case "$phase" in all|keys|enrol) ;; *) echo "Phase must be all, keys or enrol." >&2; exit 64 ;; esac',
              '[[ -t 0 && -t 1 ]] || { echo "Run from an interactive operator terminal." >&2; exit 1; }',
              'command -v ssh-keygen >/dev/null || { echo "ssh-keygen is required." >&2; exit 1; }',
              'if [[ "$phase" != keys ]]; then',
              '  [[ -x ' + shlex.quote(str(project / 'harness')) + ' ]] || { echo "Missing executable ./harness in the configured project root." >&2; exit 1; }',
              'fi', 'if [[ "$phase" != enrol ]]; then',
              '  # Check every requested destination before creating the first key.']
    for row in selected:
        for path in (row['private_key'], row['private_key'] + '.pub', row['public_key']):
            runner.append('  if [[ -e {0} || -L {0} ]]; then printf \'Refusing to overwrite existing file: %s\\n\' {0} >&2; exit 1; fi'.format(shlex.quote(path)))
    runner += ['fi', 'if [[ "$phase" == enrol ]]; then']
    for path in [anchor['private_key'], anchor['private_key'] + '.pub'] + [row['public_key'] for row in selected]:
        runner.append('  [[ -f {0} ]] || {{ printf \'Missing required key file: %s\\n\' {0} >&2; exit 1; }}'.format(shlex.quote(path)))
    runner += ['fi', 'if [[ "$phase" != enrol ]]; then']
    if all(row['mode'] != 'anchor' for row in selected):
        runner += ['  if [[ "$phase" == all ]]; then',
                   '    [[ -f {0} && -f {1} ]] || {{ echo "The unselected anchor must already have a key pair; include it with --only or generate it first." >&2; exit 1; }}'.format(shlex.quote(anchor['private_key']), shlex.quote(anchor['private_key'] + '.pub')),
                   '  fi']
    runner += ['  ' + command('bash', script) for script in generates]
    runner += ['fi', 'if [[ "$phase" != keys ]]; then']
    # Validate all exports before the first enrolment mutation.
    runner += ['  ' + command('ssh-keygen', '-lf', row['public_key']) + ' >/dev/null' for row in selected]
    runner += ['  ' + command('bash', script) for script in enrols]
    runner += ['  ' + command('bash', enrol_helper, 'check', project), 'fi',
               'printf "\\nCompleted signer setup phase: %s\\n" "$phase"']
    write_script(output / 'run-all.sh', '\n'.join(runner) + '\n')
    with (output / 'signers.resolved.csv').open('x', encoding='utf-8', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=['signer', 'identity', 'private_key', 'public_key', 'mode', 'authorities'])
        writer.writeheader()
        writer.writerows(rows)
    print('Generated scripts: ' + str(output))
    print('Selected signers: ' + ', '.join(row['identity'] for row in selected))
    print('Anchor: ' + anchor['identity'])
    if args.generate_only:
        print('Run: ' + command('bash', output / 'run-all.sh', args.phase))
        return
    print('Running phase: ' + args.phase, flush=True)
    os.dup2(3, 0)
    os.close(3)
    os.execvp('bash', ['bash', str(output / 'run-all.sh'), args.phase])


try:
    main()
except (ValueError, OSError, csv.Error) as error:
    print('Error: ' + str(error), file=sys.stderr)
    sys.exit(1)
PYTHON
