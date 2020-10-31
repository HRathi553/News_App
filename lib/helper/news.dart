import 'dart:convert';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{

  List<ArticleModel> news = [];

  Future<void> getNews() async{

    String url = "http://newsapi.org/v2/top-headlines?country=in&apiKey=a201cc02272c4d6ebe1578c483242108";                                               // Our API key...


    var response = await http.get(url);          //  Getting the response from the http url

    var jsonData = jsonDecode(response.body);   //   Decode the data

    if(jsonData['status'] == "ok"){             //   Condition applied on the data from the Api News itself
      jsonData["articles"].forEach((element){   //   Entering into the data i.e. the articles in each one by one

        if(element["urlToImage"] != null && element["description"] != null){    //  Placing the conditions on data

          ArticleModel articleModel = ArticleModel(   //  Assigning the values to the constructor
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element["content"]
          );

          news.add(articleModel);        //  Adding the data by fetching from url and adding to the list.
        }
      });
    }
  }
}

class CategoryNewsClass{

  List<ArticleModel> news = [];

  Future<void> getCategoryNews(String category) async{

    String url = "http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=a201cc02272c4d6ebe1578c483242108";                                               // Our API key...


    var response = await http.get(url);          //  Getting the response from the http url

    var jsonData = jsonDecode(response.body);   //   Decode the data

    if(jsonData['status'] == "ok"){             //   Condition applied on the data from the Api News itself
      jsonData["articles"].forEach((element){   //   Entering into the data i.e. the articles in each one by one

        if(element["urlToImage"] != null && element["description"] != null){    //  Placing the conditions on data

          ArticleModel articleModel = ArticleModel(   //  Assigning the values to the constructor
              title: element['title'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              content: element["content"]
          );

          news.add(articleModel);        //  Adding the data by fetching from url and adding to the list.
        }
      });
    }
  }
}