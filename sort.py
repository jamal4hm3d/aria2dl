import sys

file_name = sys.argv[1]

eps_map = {}
ep_links = []
eps = []

with open(f'{file_name}.unsorted','r') as reader:
    eps_reader = reader.readlines()
    for ep_read in eps_reader:
        ep_paths = ep_read.split("/")
        eps_map[ep_paths[-1]] = ep_read
        eps.append(ep_paths[-1])

eps.sort()
for ep in eps:
    ep_links.append(eps_map[ep])

with open(f'{file_name}','x') as writer:
    writer.writelines(ep_links)
