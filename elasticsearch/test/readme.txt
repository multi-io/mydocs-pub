commands:

./run.sh node{1,2,3...}

add stuff/indices:

curl -XPUT 'http://localhost:9200/twitter/user/kimchy' -d '{ "name" : "Shay Banon" }'

curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '
{ 
    "user": "kimchy", 
    "postDate": "2009-11-15T13:12:00", 
    "message": "Trying out Elastic Search, so far so good?" 
}'

curl -XPUT 'http://localhost:9200/twitter/tweet/2' -d '
{ 
    "user": "kimchy", 
    "postDate": "2009-11-15T14:12:12", 
    "message": "Another tweet, will it be indexed?" 
}'

etc.


list active nodes:

curl -XGET http://localhost:920<nodeNr>/_cluster/nodes?pretty=true
(same information from each <nodeNr>)

shards overview:

ls node*/data/olafs_elasticsearch/nodes/0/indices/twitter/


3 shards, 1 replica
===================

node1 started:

  node1: shards 0,1,2


node2 started:

  node1: shards 0,1,2
  node2: shards 0,1,2


node3 started:

  node1: shards 0,2
  node2: shards 1,2
  node3: shards 0,1


node4 started:

  node1: shards 0,2
  node2: shards 2
  node3: shards 0,1
  node4: shards 1


node5 started:

  node1: shards 0,2
  node2: shards 2
  node3: shards 1
  node4: shards 1
  node5: shards 0


node6 started:

  node1: shards 2
  node2: shards 2
  node3: shards 1
  node4: shards 1
  node5: shards 0
  node6: shards 0


node7 started:

  node1..6: no changes
  node7: shards (none)


node7 stopped:

  node1..6: no changes


node4 stopped:

  node1: shards 1,2
  node2: shards 2
  node3: shards 1
  node5: shards 0
  node6: shards 0


node5 stopped:

  node1: shards 1,2
  node2: shards 2
  node3: shards 0,1
  node6: shards 0


node1 stopped:

  node2: shards 1,2
  node3: shards 0,1
  node6: shards 0,2


node3 stopped:

  node2: shards 0,1,2
  node6: shards 0,1,2


node2 stopped:

  node6: shards 0,1,2
