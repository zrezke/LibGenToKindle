import 'package:flutter/material.dart';

class Utils {
  
  String buildRequest({@required String type, String query, List filters, String link}) {
    if (link != null) {
      link = link.replaceAll("&", '"AND"');
    }

    String request = 
      "http://10.0.2.2:5000/searchLibGen?type=$type&";
    
    switch (type) {
      case "search":
        if (filters != null) {
          request = request + "query=" + query + "&"; 
          for (int i=0; i < filters.length; i++) {
            if (filters[i] != null) {
              switch (i) {
                case 0:
                  request = request + "search_in=" + filters[i] + "&";
                  break;
                case 1:
                  request = request + "search_with_mask=" + filters[i] + "&";
                  break;  
                case 2:
                  request = request + "search_in_fields=" + filters[i] + "&";
                  break;
             }
            }
          }
        }
        request = request + "query=$query&";
        break;

      case "downloaad":
        request = request + link;
        break;
    }

    return request;
  }

}