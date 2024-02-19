A Small package for big usage
A Simple package that gives great scrolling and loading items experience for users.
which is called: Lazy loading, Load on scroll, pagination, infinity scroll etc.

## Features
* Loads Items and show as ListView or GridView
* Load More items as user scrolls
* Uses builder function so efficiently creates scrollable listview or gridview
* Very Easy to implement

## Getting started

* Add this flutter_lazy_loading package to your pubspec.yaml file under dependencies: section
* Or run the command "flutter pub add flutter_lazy_loading" in the terminal from the root of your project
* Then add "provider" package with the command "flutter pub add provider"

## Usage
 
* Go to the file where you want to add this LazyLoadingWidget
* Start with creating a LazyLoadingProvider of your required Type, for this example using Books type
```dart
ChangeNotifierProvider<LazyLoadingProvider<Books>>(
create: (context) => LazyLoadingProvider<Books>(
// passing fetchItemsMethod
fetchItems: ItemsController().fetchItems,
firstPageNumber: 1),
child: Consumer<LazyLoadingProvider<Books>>(
....
)
```
* In the above LazyProviderConstructor need to pass firstPageNumber and fetchItems Method:
* fetchItems is a method with return type of Future<ItemsResponse<Books>?>
* This method fetches the data with the parameters [page] and [offset] and 
* convert the resulted items into ItemsResponse<Books> object and returns it example given below
```dart
Future<ItemsResponse<Books>?> fetchItems(int page, int offset)async{
  List<Books> books = <Books>[];
  num end = page*offset;
  num start = end - offset;

  for(var i=start; i < (end.toInt() <= booksDataBase.length ? end.toInt() : booksDataBase.length); i++){
    final bookData = booksDataBase[i.toInt()];
    final book = Books.fromJson(bookData);
    if(book != null){
      books.add(book);
    }
  }
  await Future.delayed(Duration(seconds: 2));
  print(books);

  return books.isNotEmpty ? ItemsResponse<Books>(
      items: books,
      totalPages: booksDataBase.length~/offset
  ) : null;
}
```
* For the child parameter add Consumer of LazyLoadingProvider and in th builder return the LazyLoadingWidget
```dart
Consumer<LazyLoadingProvider<Books>>(
builder: (context, provider, _){
return LazyLoadingWidget(
provider: provider,
itemBuilder: (context, index){...}
);
}
)
```
* Last thing, for LazyLoadingWidget in the builder function create the layout of widget for your each Item
* Which decides how each item should looks
```dart
final book = provider.items?[index];
return book != null
? Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(24),
color: Colors.orange.shade200,
),
margin: const EdgeInsets.all(8),
padding: const EdgeInsets.all(8),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(Icons.menu_book_outlined, color: Colors.blue, size: 50,),
Expanded(child: Column(
children: [
Text(provider.items![index].title)
],
))
],
)
) : const SizedBox();
```

* for full example see the Example Tab

    