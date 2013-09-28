/**
 * Created with IntelliJ IDEA.
 * User: Ale
 * Date: 28-09-2013
 * Time: 16:06
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.util
{

      import com.shinho.models.dto.StampDTO;

      public class SQLhelper
      {
          public static function UpdateStampSQL(stampDetails:StampDTO):String
          {
                var sql:String = "UPDATE stampDatabase ";
                sql = sql + "SET number='" + stampDetails.number + "', ";
                sql = sql + "country='" + stampDetails.country + "', ";
                sql = sql + "type='" + stampDetails.type + "', ";
                sql = sql + "color='" + stampDetails.color + "', ";
                sql = sql + "denomination='" + stampDetails.denomination + "', ";
                sql = sql + "designer='" + stampDetails.designer + "', ";
                sql = sql + "inscription='" + stampDetails.inscription + "', ";
                sql = sql + "paper='" + stampDetails.paper + "', ";
                sql = sql + "serie='" + stampDetails.serie + "', ";
                sql = sql + "printer='" + stampDetails.printer + "', ";
                sql = sql + "perforation='" + stampDetails.perforation + "', ";
                sql = sql + "variety='" + stampDetails.variety + "', ";
                sql = sql + "watermark='" + stampDetails.watermark + "', ";
                sql = sql + "main_catalog='" + stampDetails.main_catalog + "', ";
                sql = sql + "history='" + stampDetails.history + "', ";
                sql = sql + "current_value='" + stampDetails.current_value + "', ";
                sql = sql + "cost='" + stampDetails.cost + "', ";
                sql = sql + "seller='" + stampDetails.seller + "', ";
                sql = sql + "purchase_year=" + stampDetails.purchase_year + ", ";
                sql = sql + "comments='" + stampDetails.comments + "', ";
                sql = sql + "cancel='" + stampDetails.cancel + "', ";
                sql = sql + "grade='" + stampDetails.grade + "', ";
                sql = sql + "faults='" + stampDetails.faults + "', ";
                sql = sql + "owned=" + stampDetails.owned + ", ";
                sql = sql + "used=" + stampDetails.used + ", ";
                sql = sql + "spares=" + stampDetails.spares + ", ";
                sql = sql + "condition_value=" + stampDetails.condition_value + ", ";
                sql = sql + "hinged_value=" + stampDetails.hinged_value + ", ";
                sql = sql + "centering_value=" + stampDetails.centering_value + ", ";
                sql = sql + "gum_value=" + stampDetails.gum_value + ", ";
                sql = sql + "year=" + stampDetails.year + " ";
                sql = sql + "WHERE number='" + stampDetails.number + "' AND country='" + stampDetails.country + "' AND type='" + stampDetails.type + "'";
                return sql;
          }
      }
}
