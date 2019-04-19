import csv
with open("barcelona_reviews.csv", "rt") as input, open("filtered_reviews.csv", "wt") as output:
    w = csv.writer(output)
    for record in csv.reader(input):
        w.writerow(tuple(s.replace("\n", "") for s in record))