# Sample data from the file, replace this with actual file reading if necessary
data = """
10010-03_lib951	
10011-03_lib914	1615	
10012-03_lib970	1584	737	
10205-03_lib915	1555	254	679	
10206-03_lib916	1609	36	731	248	
10207-03_lib973	1584	645	706	589	639	
""".strip().split('\n')

# Extract row labels and matrix values
row_labels = []
matrix_values = []

for row in data:
    values = row.split('\t')
    row_labels.append(values[0])
    matrix_values.append(values[1:])

# Initialize the matrix
n = len(matrix_values)  # Number of rows/columns
matrix = [['' for _ in range(n)] for _ in range(n)]

# Fill the matrix
for i, row in enumerate(matrix_values):
    for j, value in enumerate(row):
        if value:  # Skip empty values
            matrix[i][j] = value
            matrix[j][i] = value  # Ensure symmetry



# Print the symmetric matrix with row labels
print('\t' + '\t'.join(row_labels))
for i, row in enumerate(matrix):
    print(row_labels[i] + '\t' + '\t'.join(row))
