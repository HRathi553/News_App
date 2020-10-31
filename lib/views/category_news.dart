import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';

import 'article_view.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    getCategoriesNews();
  }

  getCategoriesNews() async{  //  It is not good to directly implement the data for which we have to wait to be in initState() func. directly
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getCategoryNews(widget.category);
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
          children: <Widget>[
            Text("News",
              style: TextStyle(color: Colors.black87),
            ),
            Text("Daily",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),

        actions: <Widget>[                  //  This is done just so that our AppBar has "NewsDaily" in the center.
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),     //   This icon does not really have any use just used for our purpose.
            ),
          ),
        ],

        centerTitle: true,
        elevation: 0,
      ),

      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :

      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
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