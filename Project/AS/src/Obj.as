// *************************
// * COPYRIGHT
// * DEVELOPER: MTEAM ( info@mteamapp.com )
// * ALL RIGHTS RESERVED FOR MTEAM
// * YOU CAN'T USE THIS CODE IN ANY OTHER SOFTWARE FOR ANY PURPOSE
// * YOU CAN'T SHARE THIS CODE
// *************************
/***Version log
 * 1.2 findAllClass added on 93-11-20
 * 
 * 
 */
package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**detect objects on display object with names*/
	public class Obj
	{
		/**cash all onAddEvents on this Object*/
		private static var onAddedHelper:Object = new Object();
		
		
		
		
		
		public static function get(name:String,on:DisplayObjectContainer,clas:Class=null)
		{
			var targ:* = on.getChildByName(name);
			if(clas!=null)
			{
				return (targ as clas);
			}
			
			if(targ is MovieClip)
			{
				return MovieClip(targ);
			}
			if(targ is TextField)
			{
				return TextField(targ);
			}
			return targ
		}
		
		/**remove this object from its parents*/
		public static function remove(target:DisplayObject)
		{
			if(target is MovieClip)
			{
				try
				{
					(target as MovieClip).stopAllMovieClips();
				}catch(e){};
			}
			if(target.parent!=null)
			{
				DisplayObjectContainer(target.parent).removeChild(target);
			}
		}
		
		/**generate a button from a movieClip*/
		public static function setButton(target:*,onClick:Function)
		{
			if(target!=null && target is EventDispatcher)
			{
				if(target is MovieClip)
				{
					target.mouseChildren = false ;
					target.buttonMode = true ;
				}
				target.removeEventListener(MouseEvent.CLICK,onClick);
				target.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		
		/**return true if the Target is still in the stage*/
		public static function imInStage(targ:DisplayObject):Boolean
		{
			if(targ.parent==null)
			{
				return false;
			}else if(targ.parent is Stage)
			{
				return true ;
			}
			else
			{
				return imInStage(targ.parent)
			}
		}
		
		/**move this object to top of all other objects*/
		public static function moveToFront(target:MovieClip)
		{
			var par:MovieClip = (target.parent as MovieClip);
			par.swapChildrenAt(par.getChildIndex(target),par.numChildren-1);
		}
		
		
		
		
		
		
		
		
		/**call back the onsomthingAdded function if something is added to this target*/
		public static function onAddSomething(target:MovieClip,onSomthingAdded:Function)
		{
			onAddedHelper[target] = onSomthingAdded ;
			target.addEventListener(Event.ADDED,someThingAdded);
			target.addEventListener(Event.REMOVED_FROM_STAGE,unLoaded);
		}
		
		
		/**some thing is added*/
		private static function someThingAdded(e:Event)
		{
			var target:MovieClip = MovieClip(e.currentTarget);
			if(onAddedHelper[target] is Function)
			{
				thisIsAdded(target,onAddedHelper[target]);
			}
		}
		
		/**this object is added to stage*/
		private static function thisIsAdded(target:MovieClip,onAddFunc:Function)
		{
			onAddFunc(target);
			for(var i = 0 ; i<target.numChildren ; i++)
			{
				var targ:* = target.getChildAt(i);
				if(targ is MovieClip)
				{
					thisIsAdded(targ,onAddFunc);
				}
			}
		}
		
		/**unload the */
		private static function unLoaded(e:Event)
		{
			var target:MovieClip = MovieClip(e.currentTarget) ;
			
			onAddedHelper[target] = null ;
			
			target.addEventListener(Event.ADDED,someThingAdded);
			target.addEventListener(Event.REMOVED_FROM_STAGE,unLoaded);
		}
		
//////////////////////////////////////////////////////////////
		
		/**this function will return arrray of founded object on displayObject<br>
		 * This function will returns at least one element that could be the null!*/
		public static function getAllChilds(name:String,onThe:DisplayObjectContainer):Array
		{
			var founded:Array = [] ;
			var i:int ;

			if(onThe == null)
			{
				throw "whattt???"
			}
			if( onThe.name  == name)
			{
				founded.push(onThe);
			}
			
			if(onThe is DisplayObjectContainer)
			{
				for( i = 0 ; i < onThe.numChildren ; i++)
				{
					if(onThe.getChildAt(i) is DisplayObjectContainer)
					{
						founded = getAllChilds(name,(onThe.getChildAt(i) as DisplayObjectContainer)).concat(founded);
					}
				}
			
			}
			
			//Below lines will contorll the founded items to have at least one element on the returned value.
			for(i = 0 ; i<founded.length ; i++)
			{
				if(founded[i] == null)
				{
					founded.splice(i,1);
					i--;
				}
			}
			
			if(founded.length==0)
			{
				founded.push(null);
			}
			
			return founded ;
		}
		
		
	/////////////////////////////////////////////////////////////////
		/**set the target position to this point*/
		public static function setPosition(target:DisplayObject,newPose:Point)
		{
			target.x = newPose.x;
			target.y = newPose.y;
		}
		
		/**Returns the global scale of this display object from the stage in its all parents*/
		public static function getScale(targ:DisplayObject):Number
		{
			//return targ.scaleX;
			var currentScale:Number = targ.scaleX ;
			while(targ.parent != null)
			{
				targ = targ.parent ;
				currentScale *= targ.scaleX ;
			}
			return currentScale ;
		}
		
		/**Check if this display object is visible at all of its parents*/
		public static function getVisible(targ:DisplayObject):Boolean
		{
			//return targ.visible;
			while(targ != null)
			{
				if(!targ.visible)
				{
					return false;
				}
				targ = targ.parent ;
			}
			return true ;
		}
		
		/**Check if this display object is on the stage area or not*/
		public static function getImOnStage(targ:DisplayObject):Boolean
		{
			return true;
		}
		
		
	///////////////////////////new functions ↓
		/**Fide all MovieClips on child and grand childs of this container*/
		public static function getChildIn(myName:String,container:DisplayObjectContainer):Array
		{
			var founded:Array = [] ;
			for(var i = 0 ; i<container.numChildren ; i++)
			{
				var targ:* = container.getChildAt(i) ;
				if(targ is MovieClip)
				{
					var targ2:MovieClip = targ as MovieClip ;
					if(targ2.name == myName)
					{
						founded.push(targ2);
					}
					founded = founded.concat(getChildIn(myName,targ2));
				}
			}
			return founded ;
		}
		
		/**Fide all MovieClips on child and grand childs of this container*/
		public static function findAllClass(requestedClass:Class,container:DisplayObjectContainer):Array
		{
			var founded:Array = [] ;
			for(var i = 0 ; i<container.numChildren ; i++)
			{
				var targ:* = container.getChildAt(i) ;
				if(targ is requestedClass)
				{
					founded.push(targ);
				}
				if(targ is DisplayObjectContainer)
				{
					var targ2:DisplayObjectContainer = targ as DisplayObjectContainer ;
					founded = founded.concat(findAllClass(requestedClass,targ2));
				}
			}
			return founded ;
		}
		
		
		/**Find requested class in this container.*/
		public static function findThisClass(requestedClass:Class,container:DisplayObjectContainer,searchOnGrandChilds:Boolean=false):*
		{
			for(var i = 0 ; i<container.numChildren ; i++)
			{
				var targ:* = container.getChildAt(i);
				//trace("targ is : "+targ,container);
				if(targ is requestedClass)
				{
					return targ ;
				}
				else if(targ is MovieClip && searchOnGrandChilds)
				{
					var checker:* =  findThisClass(requestedClass,targ as DisplayObjectContainer,searchOnGrandChilds);
					if(checker!=null)
					{
						//item founds 
						return checker ;
					}
				}
			}
			return null ;
		}
		
		
	//////////////////////////////////////////Class functions ↓
		
		/**Return class with this name*/
		public static function generateClass(className:String):Class
		{
			try
			{
				return (getDefinitionByName(className) as Class);
			}
			catch(e){}
			return null ;
		}
		
		public static function getObjectClass(object:*):Class
		{
			return generateClass(getQualifiedClassName(object));
		}
	
	////////////////////////////////////////////////
		public static function createReadAbleObject(obj:*):Object
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			ba.position = 0 ;
			var newObj:Object = ba.readObject();
			
			for(var i:* in newObj)
			{
				if(getQualifiedClassName(newObj[i]).indexOf("__AS3__.vec::Vector")!=-1 && newObj[i].hasOwnProperty('length'))
				{
					var arr:Array = [];
					for(var j:uint = 0 ; j<(newObj[i]).length ; j++)
					{
						arr.push(newObj[i][j]);
					}
					newObj[i] = arr ;
				}
			}
			
			return newObj ;
		}
		
	//////////////////////////////////////////////////////
		public static function playAll(target:MovieClip):void
		{
			target.play();
			for(var i = 0 ; i<target.numChildren ; i++)
			{
				if(target.getChildAt(i) is MovieClip)
				{
					playAll(target.getChildAt(i) as MovieClip);
				}
			}
		}
		
	///////////////////////////////////////////////////////
		/**Returns true if user can click the center of this object*/
		public static function isAccesibleByMouse(targ:DisplayObject,ignoreAllTextsOnTheStage:Boolean=true):Boolean
		{
			/**Parent list for current target*/
			var targParents:Vector.<DisplayObjectContainer>;
			/**It will contain targ itself*/
			var itemsOnItsArea:Array;
			var i:int,j:int,k:int;
			
			if(targ.stage == null)
			{
				trace("The item is not on stage");
				return false ;
			}
			
			//trace("targ.parent : "+targ.parent);
			//trace("targ.parent.parent : "+targ.parent.parent);
			
			targParents = new Vector.<DisplayObjectContainer>();
			var targParent:DisplayObjectContainer = targ.parent ;
			while(targParent!=targ.stage)
			{
				targParents.push(targParent);
				targParent = targParent.parent ;
			}
			
			
			targParents.push(targ.stage);
			//targParents.reverse() ;
			//trace("targParents : "+targParents);
			
			//return true ;
			
			
			var targArea:Rectangle = targ.getBounds(targ.stage);
			var targCenterPoing:Point = new Point(targArea.x+targArea.width/2,targArea.y+targArea.height/2);
			
			itemsOnItsArea = targ.stage.getObjectsUnderPoint(targCenterPoing);
			for(i = 0 ; i<itemsOnItsArea.length ; i++)
			{
				var item:* = itemsOnItsArea[i] ;
				if(targ is DisplayObjectContainer && (targ as DisplayObjectContainer).contains(item))
				{
					//trace("The targ is container of "+item);
					continue ;
				}
				if(item.hasOwnProperty('parent'))
				{
					for(j = 0 ; j<targParents.length ; j++)
					{
						if(targParents[j].contains(item))
						{
							//trace(targParents[j]+" contains the "+item);
							var targLastChild:DisplayObject ;
							if(j == 0)
							{
								targLastChild = targ ;
							}
							else
							{
								targLastChild = targParents[j-1] ;
							}
							//trace("targLastChild is : "+targLastChild);
							var canClick:Boolean = true ;
							var itemParent:DisplayObjectContainer = item.parent ;
							
							canClick = canClick && itemParent.mouseChildren ;
							
							while(itemParent!=targParents[j])
							{
								item = itemParent;
								itemParent = item.parent ;
								if(itemParent!=null)
								{
									canClick = canClick && itemParent.mouseChildren ;
								}
								else
								{
									//trace("itemParent is null now!!");
									return true ;
								}
							}
							if(item.hasOwnProperty("mouseEnabled"))
							{
								canClick = item.mouseEnabled ;
							}
							if(item == targLastChild)
							{
								//trace("Dont controll itself");
								break ;
							}
							
							if(!canClick)
							{
								//trace("The item cannot click");
								break;
							}
							
							if((ignoreAllTextsOnTheStage || targ is TextField) && item is TextField && item.parent == targ.stage)
							{
								//trace("It should be the stage text");
								break;
							}
							
							if(String(item) == "[object StageWebViewImpl]")
							{
								//trace("It is the stage themplete");
								break;
							}
							
							//trace("item.parent == targ.stage : "+(item.parent == targ.stage)+" > "+item.parent);
							//trace("targ is TextField : "+(targ is TextField)+' > '+targ);
							
							//trace("targLastChild : "+targLastChild+' > '+(targLastChild == targ));
							//trace("itemParent : "+itemParent);
							//trace("itemParent contains targ??? "+targ.parent.getChildIndex(targ)+' > '+targ.parent);
							//trace("founded target is : "+item+' item.name : '+item.name+' area : '+item.getBounds(targ.stage));
							//I found the shared parrent
							var targInsex:int = itemParent.getChildIndex(targLastChild);
							//trace("targ last child index is : "+targInsex);
							var itemIndex:int = itemParent.getChildIndex(item);
							//trace("item last child index is : "+itemIndex);
							if(itemIndex>targInsex)
							{
								//trace("Hitted!!  itemIndex:"+itemIndex+' targInsex:'+targInsex+' >>> '+item);
								return false ;
							}
							break;
						}
					}
				}
			}
			
			return true ;
		}
		
		/**Move the item to the front of others*/
		public static function moveFront(item:DisplayObject):void
		{
			// TODO Auto Generated method stub
			if(item.parent!=null)
			{
				item.parent.addChild(item);
			}
		}
		
		public static function stopAll(target:MovieClip):void
		{
			// TODO Auto Generated method stub
			target.stopAllMovieClips();
		}
		
		public static function displayObjectInfo(target:DisplayObject):String
		{
			// TODO Auto Generated method stub
			var info:String = "" ;
			var locationString:String ='';
			info += "\tName: "+target.name+'\n' ;
			info += "\tType: "+getQualifiedClassName(target)+'\n' ;
			if(target.stage)
			{
				info += "\tArea on : "+target.getBounds(target.stage)+'\n' ;
			}
			while(target!=null)
			{
				locationString=target.name+'.'+locationString;
				target = target.parent ;
			}
			info += "\tLocation: "+locationString;
			
			
			return info;
		}
	}
}