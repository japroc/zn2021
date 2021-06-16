
predicate same_attribute_store_read(SelfAttributeStore selfstore, SelfAttributeRead selfread) {
  selfstore.getName() = selfread.getName() and
  selfstore.getClass() = selfread.getClass()
}
  