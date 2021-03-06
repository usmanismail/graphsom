graphsom
===============

graphsom dumps provides visualizations for metrics collected using [folsom](https://github.com/boundary/folsom). Currently we support only [Graphite](http://graphite.wikidot.com/) visualizations but we will be adding suppor for multiple back ends soon. 

Note: [Graphite](http://graphite.wikidot.com/) is good, despite the
website being really ghetto. 

Status
------

* Supports [folsom](https://github.com/boundary/folsom) `gauge`,
  `counter` and `meter` metrics
* Supports [folsom](https://github.com/boundary/folsom) memory and statsistics Erlang VM metrics.
* Support for other metric types (`histogram` and `history`) and other
  visualization backends is coming very soon

Getting Started
--------------

Prerequisites 

* [Download](https://launchpad.net/graphite/+download) and [Install](http://graphite.wikidot.com/installation) and run graphite locally
* [Download](https://github.com/downloads/basho/rebar/rebar) or [build](https://github.com/basho/rebar) rebar.
* Clone the graphsome project 

Building graphsom

    cd graphsome
    cp path_to_rebar_bin/rebar ./ # Copy rebar to to local dir (Or somwhere in path)
	chmod u+x rebar  # Make [rebar](https://github.com/basho/rebar) executable  


    
    
Get all dependencies (only [folsom](https://github.com/boundary/folsom))

    mkdir deps
    ./rebar get-deps
    
Compile and generate a release

    ./rebar compile
    ./rebar generate
    
Running graphsom node

    ./rel/graphsom/bin/graphsom console


Graphsom will dump all `folsom metrics` every `30 seconds`
to the local graphite backend.

**Note:** Graphsom takes care of starting `folsom`

Add Some metrics:

    folsom_metrics:new_counter(metric_name_1).
    folsom_metrics:new_gauge(metric_name_2).
    folsom_metrics:new_meter(metric_name_3).

Update values for the metrics:

	folsom_metrics:notify({metric_name_1, {inc, 100}}).
    folsom_metrics:notify({metric_name_2, 200}).
    folsom_metrics:notify({metric_name_3, 300}).

Check graphite for the values:    



Authors 
------

Bilal Sheikh (<bilal@techtraits.com>)  
Usman Ismail (<usman@techtraits.com>)


