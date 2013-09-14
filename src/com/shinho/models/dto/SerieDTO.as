/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 03-02-2013
 * Time: 14:58
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models.dto {

import com.shinho.events.StampsDatabaseEvents;


public class SerieDTO {

	public var serieName:String;
	public var serieYear:String;
	public var serieStamps:Vector.<StampDTO> = Vector.<StampDTO>([]) ;

	public function SerieDTO()
	{
	}
}
}
