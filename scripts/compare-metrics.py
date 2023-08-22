import json
import pandas as pd
import sys

def read_json_file(filename):
    with open(filename, 'r') as file:
        return json.load(file)

def compare_metrics(file1, file2):
    metrics1 = file1['metrics']
    metrics2 = file2['metrics']
    
    metrics_keys = set(metrics1.keys()) | set(metrics2.keys())

    table_data = []

    for key in metrics_keys:
        value1 = metrics1.get(key, None)
        value2 = metrics2.get(key, None)

        table_data.append({
            'json_filename_1': json_filename_1,
            'json_filename_2': json_filename_2,
            'metric': key,
            'value_1': value1,
            'value_2': value2,
            'value_same': value1 == value2
        })

    return table_data

def main(json_filename_1, json_filename_2, output_table_name):
    json_file1 = read_json_file(json_filename_1)
    json_file2 = read_json_file(json_filename_2)

    result = compare_metrics(json_file1, json_file2)

    df = pd.DataFrame(result)
    df[~df['value_same']].to_csv(path_or_buf=output_table_name, index=False, sep="\t")

    print(f"Comparison saved to {output_table_name}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: script.py <json_filename_1> <json_filename_2> <output_table_name>")
        sys.exit(1)

    json_filename_1 = sys.argv[1]
    json_filename_2 = sys.argv[2]
    output_table_name = sys.argv[3]
    main(json_filename_1, json_filename_2, output_table_name)
