---
layout: post
title: Slow Query Tracking
comments: true
disqus_id: slow-query-tracking
tags:
  - Drupal 8
  - Views
  - SQL
  - Performance
---

Recently I was asked a question about how best to create a view that showed only parents with children. This seems like a simple request but it is quite complex with the Views UI. This lead me down the path of query altering at which point I remembered [a post](https://jacobbednarz.com/posts/tracking-sql-queries), an idea a colleague of mine came up with. I thought to myself - we need to include some tagging on this query, so I began furiously searching for the same idea in Drupal 8. Much to my surprise there are a number of ways we can provide additional information around queries in D8, tagging is one of them. This however wasn't what I was thinking of so I dug in to find the differences between these methods.

I'd like to emphasise; if we're changing queries, especially those generated by a UI, we should add some logging around the query so that future developers can understand what decisions were made and where exactly the query comes from.

## Query comments

```
Drupal\Core\Database\Select::comment()
```

Query comments are what I was looking for, not tagging. Drupal 8 supports these via the comment method. The interesting thing about comments is that they are prepended with the query and sent to the RDBMS. This means that the comments appear in your logs. Take the following query for instance:

```
SELECT *
FROM node
```

This query doesn't tell us much, other than it is select all fields from our users table. If we're inspecting the slow query log we can see that this query is slow but we can't see where this query comes from. This is where comments can help, we can use `hook_query_alter` to add some information like:

{% highlight php %}
$query->comment('module:my_module|function:' . __CLASS__ . '::' . __METHOD__);
{% endhighlight %}

This will change the compiled query to match:

```
/* module:my_module|class:myClass|method:render */
SELECT *
FROM node
```

As long as the comment is a string we can add all sorts of valuable information to assist with debugging slow queries. This will allow developers to understand exactly where the query is coming from. Another good thing to note is that [comments don't impact performance](https://sqlperformance.com/2016/11/sql-performance/comments-hamper-performance) of queries.

Unlike the other metadata providers, comments are more set and forget, they do not have accessors nor mutators from the default query object. Once you set one the only way to view it is through `__toString()`.

## Query tagging

```
Drupal\Core\Database\Select::addTag()
```

Tagging a query allows modules to provide additional context to the query and can be used by other modules when performing query alters. Tags need to follow PHP variable naming conventions. The tags are only held in memory during the request that is building the query and do not alter the generated SQL.

The Query object provides utility methods for analysing the object; `hasTag`, `hasAllTags`, `hasAnyTags`. These can be used to inspect the query and operate accordingly.

*Note* Views applies some tags to all queries that are generated, it is beneficial to use these if you need to query alter (rather than inspecting the views object directly). They use **views** and **views_<view_name>**.

**Example**

{% highlight php %}
$query->addTag('views');
$query->addTag('views_content_list');

if ($query->hasTag('views_name')) {
  // do thing.
}
if ($query->hasAnyTag('something', 'something_else', 'views')) {
  // do this if any tags in the arguments are present.
}
if ($query->hasAllTags('views', 'views_content_list')) {
  // do this if all tags are present.
}

{% endhighlight %}

## Query metadata

```
Drupal\Core\Database\Select::addMetaData()
```

Metadata can be used much the same way as query tagging however metadata surrounding the query can be complex objects. The goal of the metadata is to provide additional context to a query so that it can be altered. Similarly to tags, this doesn't alter the SQL generated.

The query object provides utility methods for accessing and updating a queries metadata; `addMetaData`, `getMetaData` respectively.

{% highlight php %}

$query->addMetaData('node', $node);
$query->getMetaData('node'); // \Drupal\Entity\Node;

{% endhighlight %}

## Practical examples

Recently we came across a need to provide a second query to further filter views as the views UI doesn't provide the necessary options to do this. To ensure that the code is maintainable we added some comments to the views query so it was easily identifiable that we were modifying it with a module. Here is the code!

For completeness - the views `QueryPluginBase` object is provided by the views module and contains a reference to the Core query object; to add comments we need to access the query object directly.

{% highlight php %}

function my_module_views_query_alter(ViewExecutable $view, QueryPluginBase &$query) {
  if ($query->hasTag('view_my_view')) {
    $sub_query = \Drupal::database->select('taxonomy_term_hierarchy', 't')
      ->fields('t.tid')
      ->groupBy('t.parent')
      ->execute();
    $terms_with_parents = $sub_query->fetchAll(\PDO::FETCH_ASOC);

    $query->query->comment('module:my_module|function:' . __FUNCTION__);
  }
}

{% endhighlight %}

## More information

- [Query alteration and tagging](https://www.drupal.org/docs/7/api/database-api/dynamic-queries/query-alteration-tagging)
- [Slow query tracking](https://jacobbednarz.com/posts/tracking-sql-queries)
