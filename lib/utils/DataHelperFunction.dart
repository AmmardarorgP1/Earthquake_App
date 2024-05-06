class DataHelper
{

  static int toInt(num value)
  {
    try
        {
          if(value == null)
            {
              return 0;
            }
          else if (value is int)
            {
              return value;
            }
          else
            {
              return value.toInt();
            }
        }
        catch(error)
    {
      print(error);
      return 0;
    }
  }

 static double toDouble(num value)
 {
   try
       {
         if(value == null)
           {
             return 0;
           }
         else if (value is double)
           {
             return value;
           }
         else
           {
             return value.toDouble();
           }
       }
       catch(error)
   {
     print(error);
     return 0;
   }
 }


}