class BopItAction
{
   String action;
   Movie actionMovie;
   
   BopItAction(String a,Movie aMovie)
   {
      action = a;
      actionMovie = aMovie;
   }
   
   Movie getMovie()
   {
       return actionMovie; 
   }
   
  String getAction()
  {
     return action;
  }
}
