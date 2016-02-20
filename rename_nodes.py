seen = set()
with open("edges.txt") as f:
    for l in f:
        node1, node2 = l.split()
        seen.add(int(node1))
        seen.add(int(node2))

mapping = {v: i for i, v in enumerate(seen, start=1)}

with open("edges.txt") as src, open("out_edges.txt", "w") as dst:
    for l in src:
        node1, node2 = l.split()
        dst.write(str(mapping[int(node1)]))
        dst.write(" ")
        dst.write(str(mapping[int(node2)]))
        dst.write("\n")

with open("vert.txt") as src, open("out_term.txt", "w") as dst:
    for l in src:
        term = int(l)
        try:
            dst.write(str(mapping[term]))
            dst.write("\n")
        except KeyError:
            pass

with open("out_mapping.txt", "w") as f:
    for m, t in mapping.items():
        f.write(str(m))
        f.write(str(" "))
        f.write(str(t))
        f.write("\n")
