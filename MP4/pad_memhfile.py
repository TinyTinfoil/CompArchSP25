import sys

infilename = sys.argv[1]
filename_parts = infilename.split('.')
outfilename0 = filename_parts[0] + '.txt'
with open(infilename, 'r') as infile:
    lines = infile.read().splitlines()[1:]
    lines = [line.replace(' ', '\n') for line in lines]
    lines = '\n'.join(lines).splitlines()
    lines = [line.lower() for line in lines]
    lines += ['00000000'] * (2048 - len(lines))
    with open(outfilename0, 'w') as outfile:
        outfile.write('\n'.join(lines) + '\n')