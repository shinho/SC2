/**
 * Created with IntelliJ IDEA.
 * User: Ale
 * Date: 12-11-2013
 * Time: 23:32
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.util
{


      import flash.filesystem.File;

      public class FileHelper
      {
            public static const DIR_HOME:String = "Stampit";
            public static const DIR_IMAGES:String = DIR_HOME + File.separator + "Images";
            public static const DIR_EXPORT:String = DIR_HOME + File.separator + "Export";
            public static const DIR_IMPORT:String = DIR_HOME + File.separator + "Import";
            public static const DATABASE_NAME:String = "stampsDatabase.db";


            public static function getFile( country:String, type:String, number:String ):File
            {
                  var slash:String = File.separator;
                  var imageFile:File = File.documentsDirectory.resolvePath( DIR_IMAGES + slash + country + slash + type + slash + number + ".jpg" );
                  return imageFile;
            }


            public static  function getRootDir():File
            {
                  return File.documentsDirectory.resolvePath( DIR_HOME );
            }

            public static function getImagesDir():File
            {
                  return File.documentsDirectory.resolvePath( DIR_IMAGES );
            }

            public static function getImportDir():File
            {
                  return File.documentsDirectory.resolvePath( DIR_IMPORT );
            }

            public static function getExportDir():File
            {
                  return File.documentsDirectory.resolvePath( DIR_EXPORT );
            }

            public static function getCountryExportFile(country:String):File
            {
                  return File.documentsDirectory.resolvePath(DIR_EXPORT + File.separator + country + ".xml");
            }

            public static function getDatabase():File
            {
                  return File.documentsDirectory.resolvePath( DIR_HOME + File.separator + DATABASE_NAME );
            }



      }
}
