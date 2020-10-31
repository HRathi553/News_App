import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'article_view.dart';
import 'category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState(){
    super.initState();
    categories = getCategories();       //  On starting the homescreen we are fetching all the data.dart file List items in the List "categories" for our News Categories.

    getNews();
  }

  getNews() async{  //  It is not good to directly implement the data for which we have to wait to be in initState() func. directly
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;    //  On starting the homescreen we are fetching all the news.dart file List items in the List "articles" for our News

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("News",
            style: TextStyle(color: Colors.black87),
            ),
            Text("Daily",
            style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      )

          : SingleChildScrollView(
            child: Container(               //    This bigger container consists of all the list.
              padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
            children: <Widget> [
              Container(
                height: 70,                   //  We have to mention this bcoz the height of the images are 60 so we have to provide extra height..
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,             //  Finding the length of the list
                    itemBuilder: (context,index){
                      return CategoryTile(                    //  ListView.builder --> itemBuilder needs to return a widget here CategoryTile which is building our "categories of news" of size 120*60
                        imageUrl: categories[index].imageUrl,
                        categoryName: categories[index].categoryName, //  context is for widget tree and index is like count of widgets.
                      );
                 }                                                   // So value of imageUrl and CategoryName is passed to Category Tile one by one and a list of horizontal Containers are building one by one.
                ),
              ),

              /// Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                    shrinkWrap: true,               //  Whenever a ListView.builder is inside a Column use of shrinkWrap is must.
                    physics: ClampingScrollPhysics(), //  My blogs will not be scrollable and i could not see them.
                    itemCount: articles.length,
                    itemBuilder: (context,index){
                      return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url,
                      );
                    },
                ),
              )
            ],
        ),
      ),
          ),
    );
  }
}

class CategoryTile extends StatelessWidget {          //  This is building our "News Category" list by providing the Container one by one!

  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: categoryName.toLowerCase(),
            )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget> [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl: imageUrl, width: 120, height: 65, fit: BoxFit.cover,)
            ),
            Container(
              width: 120, height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Text(categoryName, style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl, title, desc, url;
  BlogTile({@required this.imageUrl, @required this.title, @required this.desc, @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(
              blogUrl: url
            ),
        ),);
      },
      child: Container(
        child: Column(
          children: <Widget> [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)
            ),
            SizedBox(height: 8),
            Text(title, style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 8),
            Text(desc, style: TextStyle(
              color: Colors.black54
            ),),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
