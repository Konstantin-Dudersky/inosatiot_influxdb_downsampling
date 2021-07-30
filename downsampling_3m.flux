option task = {name: "downsampling_3m", every: 1h}

fields = ["p", "q"]
data = from(bucket: "inosatiot_resources_sim")
	|> range(start: -1d)
	|> filter(fn: (r) =>
		(contains(value: r._field, set: fields)))

data
	|> aggregateWindow(fn: mean, every: 3m, createEmpty: false)
	|> tail(n: 100000000000, offset: 1)
	|> filter(fn: (r) =>
		(exists r._value))
	|> to(bucket: "inosatiot_resources_sim_3m", org: "Inosat")