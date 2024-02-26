import 'package:flutter/material.dart';
import 'package:flutter_lazy_loading/flutter_lazy_loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Shop"),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Top Selling Books",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary),
                ))
              ],
            ),
          ),
          Expanded(
              // wrap the Lazy loading widget with the change notifier of LazyLoadingProvider
              child: ChangeNotifierProvider<LazyLoadingProvider<Books>>(
            create: (context) => LazyLoadingProvider<Books>(
                // passing fetchItemsMethod
                fetchItems: ItemsController().fetchItems,
                firstPageNumber: 1),
            child: Consumer<LazyLoadingProvider<Books>>(
              builder: (context, provider, _) {
                return LazyLoadingWidget(
                    provider: provider,
                    gridView: true,
                    gridViewCrossAxisCount: 3,
                    itemWidget: (book) {
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.orange.shade200,
                          ),
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                color: Colors.blue,
                                size: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    book.description,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text("Price"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(book.mrp.toString(),
                                          style: TextStyle(
                                              color: Colors.black26,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(book.mrp.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ));
                    });
              },
            ),
          ))
        ],
      ),
    );
  }
}

class ItemsController {
  Future<ItemsResponse<Books>?> fetchItems(int page, int offset) async {
    List<Books> books = <Books>[];
    num end = page * offset;
    num start = end - offset;

    for (var i = start;
        i <
            (end.toInt() <= booksDataBase.length
                ? end.toInt()
                : booksDataBase.length);
        i++) {
      final bookData = booksDataBase[i.toInt()];
      final book = Books.fromJson(bookData);
      if (book != null) {
        books.add(book);
      }
    }
    await Future.delayed(Duration(seconds: 2));
    print(books);

    return books.isNotEmpty
        ? ItemsResponse<Books>(
            items: books, totalPages: booksDataBase.length ~/ offset)
        : null;
  }
}

List<Map<String, dynamic>> booksDataBase = [
  {
    'id': 1,
    'title': 'Unlocking Android',
    'description':
        "Unlocking Android: A Developer's Guide provides concise, hands-on instruction for the Android operating system and development tools. This book teaches important architectural concepts in a straightforward writing style and builds on this with practical and useful examples throughout.",
    'price': 939,
    'mrp': 2186
  },
  {
    'id': 2,
    'title': 'Android in Action, Second Edition',
    'description':
        'Android in Action, Second Edition is a comprehensive tutorial for Android developers. Taking you far beyond "Hello Android," this fast-paced book puts you in the driver\'s seat as you learn important architectural concepts and implementation strategies. You\'ll master the SDK, build WebKit apps using HTML 5, and even learn to extend or replace Android\'s built-in features by building useful and intriguing examples. ',
    'price': 1149,
    'mrp': 2457
  },
  {
    'id': 3,
    'title': 'Specification by Example',
    'description': "No Description Available",
    'price': 1859,
    'mrp': 1866
  },
  {
    'id': 4,
    'title': 'Flex 3 in Action',
    'description': "No Description Available",
    'price': 429,
    'mrp': 2288
  },
  {
    'id': 5,
    'title': 'Flex 4 in Action',
    'description': "No Description Available",
    'price': 669,
    'mrp': 1318
  },
  {
    'id': 6,
    'title': 'Collective Intelligence in Action',
    'description': "No Description Available",
    'price': 1859,
    'mrp': 1940
  },
  {
    'id': 7,
    'title': 'Zend Framework in Action',
    'description':
        'Zend Framework in Action is a comprehensive tutorial that shows how to use the Zend Framework to create web-based applications and web services. This book takes you on an over-the-shoulder tour of the components of the Zend Framework as you build a high quality, real-world web application.',
    'price': 1559,
    'mrp': 1839
  },
  {
    'id': 8,
    'title': 'Flex on Java',
    'description':
        '   A beautifully written book that is a must have for every Java Developer.       Ashish Kulkarni, Technical Director, E-Business Software Solutions Ltd.',
    'price': 1609,
    'mrp': 2310
  },
  {
    'id': 9,
    'title': 'Griffon in Action',
    'description':
        "Griffon in Action is a comprehensive tutorial written for Java developers who want a more productive approach to UI development. In this book, you'll immediately dive into Griffon. After a Griffon orientation and a quick Groovy tutorial, you'll start building examples that explore Griffon's high productivity approach to Swing development. One of the troublesome parts of Swing development is the amount of Java code that is required to get a simple application off the ground.",
    'price': 1219,
    'mrp': 1577
  },
  {
    'id': 10,
    'title': 'OSGi in Depth',
    'description':
        'Enterprise OSGi shows a Java developer how to develop to the OSGi Service Platform Enterprise specification, an emerging Java-based technology for developing modular enterprise applications. Enterprise OSGi addresses several shortcomings of existing enterprise platforms, such as allowing the creation of better maintainable and extensible applications, and provide a simpler, easier-to-use, light-weight solution to enterprise software development.',
    'price': 1179,
    'mrp': 1495
  },
  {
    'id': 11,
    'title': 'Flexible Rails',
    'description':
        '"Flexible Rails created a standard to which I hold other technical books. You definitely get your money\'s worth."',
    'price': 1479,
    'mrp': 2425
  },
  {
    'id': 13,
    'title': 'Hello! Flex 4',
    'description':
        "Hello! Flex 4 progresses through 26 self-contained examples selected so you can progressively master Flex. They vary from small one-page apps, to a 3D rotating haiku, to a Connect Four-like game. And in the last chapter you'll learn to build a full Flex application called SocialStalkr   a mashup that lets you follow your friends by showing their tweets on a Yahoo map.",
    'price': 1549,
    'mrp': 2214
  },
  {
    'id': 14,
    'title': 'Coffeehouse',
    'description':
        'Coffeehouse is an anthology of stories, poems and essays originally published on the World Wide Web.',
    'price': 1469,
    'mrp': 1641
  },
  {
    'id': 15,
    'title': 'Team Foundation Server 2008 in Action',
    'description': "No Description Available",
    'price': 1299,
    'mrp': 1651
  },
  {
    'id': 16,
    'title': 'Brownfield Application Development in .NET',
    'description':
        "Brownfield Application Development in .Net shows you how to approach legacy applications with the state-of-the-art concepts, patterns, and tools you've learned to apply to new projects. Using an existing application as an example, this book guides you in applying the techniques and best practices you need to make it more maintainable and receptive to change.",
    'price': 489,
    'mrp': 1788
  },
  {
    'id': 17,
    'title': 'MongoDB in Action',
    'description':
        'MongoDB In Action is a comprehensive guide to MongoDB for application developers. The book begins by explaining what makes MongoDB unique and describing its ideal use cases. A series of tutorials designed for MongoDB mastery then leads into detailed examples for leveraging MongoDB in e-commerce, social networking, analytics, and other common applications.',
    'price': 659,
    'mrp': 2176
  },
  {
    'id': 18,
    'title': 'Distributed Application Development with PowerBuilder 6.0',
    'description': "No Description Available",
    'price': 1049,
    'mrp': 1992
  },
  {
    'id': 19,
    'title': 'Jaguar Development with PowerBuilder 7',
    'description':
        'Jaguar Development with PowerBuilder 7 is the definitive guide to distributed application development with PowerBuilder. It is the only book dedicated to preparing PowerBuilder developers for Jaguar applications and has been approved by Sybase engineers and product specialists who build the tools described in the book.',
    'price': 769,
    'mrp': 1870
  },
  {
    'id': 20,
    'title': 'Taming Jaguar',
    'description': "No Description Available",
    'price': 839,
    'mrp': 846
  },
  {
    'id': 21,
    'title': '3D User Interfaces with Java 3D',
    'description': "No Description Available",
    'price': 1289,
    'mrp': 1842
  },
  {
    'id': 22,
    'title': 'Hibernate in Action',
    'description': '"2005 Best Java Book!" -- Java Developer\'s Journal',
    'price': 589,
    'mrp': 683
  },
  {
    'id': 23,
    'title': 'Hibernate in Action (Chinese Edition)',
    'description': "No Description Available",
    'price': 1169,
    'mrp': 2200
  },
  {
    'id': 24,
    'title': 'Java Persistence with Hibernate',
    'description':
        '"...this book is the ultimate solution. If you are going to use Hibernate in your application, you have no other choice, go rush to the store and get this book." --JavaLobby',
    'price': 189,
    'mrp': 1584
  },
  {
    'id': 25,
    'title': 'JSTL in Action',
    'description': "No Description Available",
    'price': 649,
    'mrp': 2456
  },
  {
    'id': 26,
    'title': 'iBATIS in Action',
    'description':
        '   Gets new users going and gives experienced users in-depth coverage of advanced features.       Jeff Cunningham, The Weather Channel Interactive',
    'price': 129,
    'mrp': 1053
  },
  {
    'id': 27,
    'title': 'Designing Hard Software',
    'description':
        '"This book is well written ... The author does not fear to be controversial. In doing so, he writes a coherent book." --Dr. Frank J. van der Linden, Phillips Research Laboratories',
    'price': 1149,
    'mrp': 1349
  },
  {
    'id': 28,
    'title': 'Hibernate Search in Action',
    'description':
        '"A great resource for true database independent full text search." --Aaron Walker, base2Services',
    'price': 1949,
    'mrp': 2326
  },
  {
    'id': 29,
    'title': 'jQuery in Action',
    'description':
        '"The best-thought-out and researched piece of literature on the jQuery library." --From the forward by John Resig, Creator of jQuery',
    'price': 1569,
    'mrp': 1661
  },
  {
    'id': 30,
    'title': 'jQuery in Action, Second Edition',
    'description':
        'jQuery in Action, Second Edition is a fast-paced introduction to jQuery that will take your JavaScript programming to the next level. An in-depth rewrite of the bestselling first edition, this edition provides deep and practical coverage of the latest jQuery and jQuery UI releases. The book\'s unique "lab pages" anchor the explanation of each new concept in a practical example. You\'ll learn how to traverse HTML documents, handle events, perform animations, and add Ajax to your web pages. This comprehensive guide also teaches you how jQuery interacts with other tools and frameworks and how to build jQuery plugins. ',
    'price': 1819,
    'mrp': 2290
  },
  {
    'id': 31,
    'title': 'Building Secure and Reliable Network Applications',
    'description':
        '"... tackles the difficult problem of building reliable distributed computing systems in a way that not only presents the principles but also describes proven practical solutions." --John Warne, BNR Europe',
    'price': 1609,
    'mrp': 1824
  },
  {
    'id': 32,
    'title': 'Ruby for Rails',
    'description':
        'The word is out: with Ruby on Rails you can build powerful Web applications easily and quickly! And just like the Rails framework itself, Rails applications are Ruby programs. That means you can   t tap into the full power of Rails unless you master the Ruby language.',
    'price': 1239,
    'mrp': 1357
  },
  {
    'id': 33,
    'title': 'The Well-Grounded Rubyist',
    'description':
        'What would appear to be the most complex topic of the book is in fact surprisingly easy to assimilate, and one realizes that the efforts of the author to gradually lead us to a sufficient knowledge of Ruby in order to tackle without pain the most difficult subjects, bears its fruit.       Eric Grimois, Developpez.com',
    'price': 769,
    'mrp': 2006
  },
  {
    'id': 35,
    'title': "Website Owner's Manual",
    'description':
        "Website Owner's Manual helps you form a vision for your site, guides you through the process of selecting a web design agency, and gives you enough background information to make intelligent decisions throughout the development process. This book provides a jargon-free overview of web design, including accessibility, usability, online marketing, and web development techniques. You'll gain a practical understanding of the technologies, processes, and ideas that drive a successful website.",
    'price': 599,
    'mrp': 912
  }
];

class Books {
  String id;
  String title;
  String description;
  num sellingPrice;
  num mrp;
  Books(
      {required this.id,
      required this.title,
      required this.description,
      required this.sellingPrice,
      required this.mrp});
  static Books? fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final title = json["title"];
    final description = json["description"];
    final price = num.tryParse(json["price"].toString());
    final mrp = num.tryParse(json["mrp"].toString());

    if (id != null &&
        title is String &&
        description is String &&
        price is num &&
        mrp is num &&
        price < mrp) {
      return Books(
          id: id.toString(),
          title: title,
          description: description,
          sellingPrice: price,
          mrp: mrp);
    }
    return null;
  }
}
