#!/usr/bin/python3

import re
import ast
import json
import argparse
from pathlib import Path

def convert(value):
    try:
        return ast.literal_eval(value)
    except (ValueError, SyntaxError):
        return value

def safe_eval_dict(d):
    return {k: convert(v) for k, v in d.items()}

def prep_for_json(string):
    if not isinstance(string, str):
        string = str(string)
    return re.sub(r'(["\'])', lambda m: '\\"' if m.group() == '"' else '"', string)

def attempt_json(string, pretty=False):
    try:
        res = json.loads(string)
        res = {"ok": True, "data": res, "messages": []}
        if pretty:
            res = json.dumps(res, indent=4)
        return res
    except Exception as e:
        return {"ok": False, "data": "" if pretty else {}, "messages": [str(e)]}

def file_to_dict(file_path, delimiter=':|='):
    path = Path(file_path)
    try:
        with path.open('r') as file:
          return {k.strip(): v.strip() for line in file if re.search(delimiter, line) for k, v in [re.split(delimiter, line, 1)]}
    except Exception as e:
        print(str(e))
        return {}

def main():
    parser = argparse.ArgumentParser(
        description="create a dictionary from a file.",
        epilog="example: python ftd.py some.txt -d '-' -o output.txt"
    )
    parser.add_argument('file', help='path to input text file', type=str)
    parser.add_argument('-d', '--delimiter', default=':|=', help="custom regex delimiter (default: ':|=')")
    parser.add_argument('-p', '--pretty', action='store_true', help='output nicely formatted json string')
    parser.add_argument('-o', '--output', help='output file path (optional)')
    args = parser.parse_args()

    result = file_to_dict(args.file, args.delimiter)
    if result:
        result = safe_eval_dict(result)
        result = prep_for_json(result)
        result = attempt_json(result, args.pretty)
    else:
        result = {"ok": True, "data": "" if args.pretty else {}, "messages": ["produced empty result"]}

    if args.output:
        with open(args.output, 'w') as f:
            for row in result:
                f.write(",".join(str(row) if row else "") + "\n")
        print(f"results written to {args.output}")
    else:
        print(result)

if __name__ == "__main__":
    main()
