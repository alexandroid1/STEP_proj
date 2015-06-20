// search index for WYSIWYG Web Builder
var database_length = 0;

function SearchPage(url, title, keywords, description)
{
   this.url = url;
   this.title = title;
   this.keywords = keywords;
   this.description = description;
   return this;
}

function SearchDatabase()
{
   database_length = 0;
   this[database_length++] = new SearchPage("index.html", "Ximple", "ximple simple is portal where any company can post information about themselves their products and services customers make order buy these home help faq contact search this website log in user name password nbsp remember me category1 subcategory1 subcategory2 subcategory3 subcategory4 category2 category3 category4 category5 category6 category7 category8 category9 category10 category11 category12 category13 category14 ", "Simple Ximple is a portal  where any company can post information about themselves  their products and services  and customers can make order and buy these products ");
   return this;
}
