#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time   : 06/02/2020
# @Author : aimkiray
# @Email  : root@meowwoo.com

import re

text = '''{QmTd6UvR47vUidRNZ1ZKXHrAFhqTJAD27rKL9XYghEKgKX: [/ip4/147.75.67.199/tcp/4001]}
{12D3KooWRCzLfXMeVonBkG2rtLfXbaKE8zUcTUaNHbUML5GcfdQd: [/ip4/103.39.231.199/tcp/35661]}
{12D3KooWQ4UrZxqGcBciw9c1AFQG97BUfzt6iSZj7QJkUbDy3s7K: [/ip4/103.39.231.199/tcp/44921]}
{12D3KooWPTXAeCA9tcHWXkVhHmDUVhdi38xMrMwfGdhYbDkLkDLk: [/ip4/111.19.129.173/tcp/39211]}
{12D3KooWPJHAWME1Wn5Qnve2etmGe9Mp9FJqNHF9KJB1mGokAZCp: [/ip4/103.44.146.197/tcp/39509]}
{12D3KooWHiqAk9dnBVjk5CLY1SCFidSzkWWoS3zU5dCHB9p3HgnK: [/ip4/103.39.218.170/tcp/37293]}
{12D3KooWHGnkDi3HDF96QZY3SNPcnjQzTyNo2KzwsvPYShjKXePb: [/ip4/103.44.146.194/tcp/39349]}
{12D3KooWFhF5tnm5gfgJqjXyPCLKqSc2ZQLEgx3dQwa1VecobzRG: [/ip4/61.238.124.55/tcp/43549]}
{12D3KooWFLFJYKhmLyufzrgtVmUQuCUgmebQ1MWjFmeuBnQXN4k5: [/ip4/103.44.146.203/tcp/38301]}
{12D3KooWF4zCJtnGxuH1NgnD8NdvpFJZvDVrPoLrw7jQgpU6jk6G: [/ip4/222.93.188.124/tcp/59851]}
{12D3KooWEz7uhRZ1Bz28DKUNpFBeHvvStwe8MJbBHN7w6WAQS9Yr: [/ip4/103.44.146.213/tcp/34751]}
{12D3KooWDrQo2GBHQNMFeNCGFgp5igiN1zZEEjKMc4QJJmiFGdbW: [/ip4/103.44.146.203/tcp/43285]}
{12D3KooWDBEhZzHK3CUGVmvBAXezLmz1as61o8VKkLXFpJSsycNk: [/ip4/111.19.129.175/tcp/35109]}
{12D3KooWCzBEDmCcZ4qvz1A5QN5CQN4AmgmfQcnjKJApTpexE9e3: [/ip4/103.44.146.213/tcp/39989]}
{12D3KooWBSnBGmdPM9TkGpgtB9PLWKJp3wzSbS1BmjYhQDPhuXv2: [/ip4/61.238.124.55/tcp/45567]}
{12D3KooWAw43KSbummjBugsMUPpMDaCGUq2ByzxxstnetwXSUoZx: [/ip4/103.44.146.197/tcp/37863]}
{12D3KooWANssqcJnQw4agyFHQnwZJKsA5WnQj6Ut4j3ibwN837bn: [/ip4/222.93.188.124/tcp/51793]}'''

if __name__ == '__main__':
    result = re.sub(r'{(.*): \[(.*)\]}', r'lotus net connect \2/p2p/\1', text)
    print(result)
