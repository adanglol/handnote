// where we will filter out our Stream which is list of Database notes only for our user and not others

// doing like this so we can grab hold of content of stream in our extension
extension Filter<T> on Stream<List<T>> {
  // we have stream containing list of things
  // we want stream of list of same thing as long as those individual thiing pass specific test where specified by where clause
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
