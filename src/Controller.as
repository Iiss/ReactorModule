package  
{
	import models.*;
	/**
	 * ...
	 * @author liss
	 */
	public class Controller 
	{
		private var _model:MainDataModel;
		
		public function Controller(model:MainDataModel) 
		{
			_model = model;
		}
		
		public function toggleTurbineSystemLock():void
		{
			_model.lockOpened = !_model.lockOpened;
			checkGenerators();
			_model.update();
		}
		
		public function toggleTurbine(turbine:TurbineDataModel):void
		{
			//old ->> turbine.turnedOn == 1 ? turbine.turnedOn = 0:turbine.turnedOn = 0;
			turbine.turnedOn ? turbine.turnedOn = false:turbine.turnedOn = false;
			checkGenerators();
			_model.update();
		}
		
		public function pushSelection(sel:*):void
		{
			if (sel is Array)
			{
				if (_model.curElementType != sel[0].type) _model.curElement.length = 0;
				_model.curElement = _model.curElement.concat(sel);
				_model.curElementType = sel[0].type;
				
				for each(var element:ReactorElementDataModel in sel)
				{
					element.selected = true;
				} 
			}
			else if(sel is ReactorElementDataModel)
			{
				if (_model.curElementType != sel.type) _model.curElement.length = 0;
				_model.curElement.push(sel);
				_model.curElementType = sel.type;
				
				sel.selected = true;
			}
			else 
			{
				throw new Error('Controller.as pushSelection(). Wrong argument type! Only ReactorElementDataModel and Vector.<ReactorElementDataModel> are allowed')
				return;
			}
			
			_model.update();
		}
		
		public function clearSelection():void
		{
			for each(var sel:ReactorElementDataModel in _model.curElement)
			{
				sel.selected = false;
			}
			_model.curElement.length = 0;
			_model.curElementType = '';
			_model.update();
		}
		
		public function addReactorElementDataModel(el:*):void
		{
			switch (true)
			{
				case el is TvelDataModel: 		
					_model.tvels.push(el); 		
					break;
					
				case el is RodDataModel:			
					_model.rods.push(el);	 	
					
					if (!_model.rodDependencies[el.dependency.stack]) 
						_model.rodDependencies[el.dependency.stack] = new Array;
					
					_model.rodDependencies[el.dependency.stack].push(el);
					break;
				
				case el is TurbineDataModel: 	
					_model.turbines.push(el);	
					break;
			}
		}
		
		private function checkGenerators():void
		{
			_model.generatorActive = 0;
			
			for each(var turbine:TurbineDataModel in _model.turbines)
			{
				if (turbine.durability <= 0)
				{
					turbine.turnedOn = false;
					//generator.g1.vRotor = 0;//??????	
				}
				_model.generatorActive += turbine.turnedOn;
			}
			
			_model.kg = 0;
			if(_model._globalB > 0) _model.kg = 0.1 + _model._globalB/1000;			
		}
		
		
		private function burnTVEL(center:TvelDataModel, power:Number):void
		{
			var explosionPower:Number = Math.sqrt(power)*(1+Math.random())/100;
			center.durability -= explosionPower;
			
			if(center.durability <= 0.001){
				center.durability = 0.001;
				
			}else{
				/*
				if(center.exlosions < 10-center.durability/10){
					
					var TVELSize:Number = 40;
					//soundExplosion.start();
					
					newExpl = center.attachMovie("explosion", "explosion", center.getNextHighestDepth())
					
					newExpl.x = (Math.random() - 0.5) * TVELSize
					newExpl.y = (Math.random() - 0.5) * TVELSize } );
					
					newExpl.ds = Math.sqrt(explosionPower)*1000;
					
					center.exlosions += explosionPower;
				}*/
			}
		}
		
		public function stopReactor(e:*=null):void
		{
			for each(var rod:RodDataModel in _model.rods) 
				rod.movingTo = 1000;
		}
		
		public function pullTVEL(e:*=null):void
		{
			(_model.curElement[0] as TvelDataModel).pulling = true;
		}
		
		public function pushTVEL(e:*=null):void
		{
			(_model.curElement[0] as TvelDataModel).pushing = true;
		}
		
		public function changeTVEL(e:*=null):void
		{
			var tvel:TvelDataModel = _model.curElement[0] as TvelDataModel;
	
			
			if (!tvel) return;
			
			if(tvel.deep <= 0){
				//trace("change");
				tvel.exlosions = 0;
				//curElement[0].h._xscale = allR[i].h._yscale = allR[i].shad._xscale = allR[i].shad._yscale = 0;
				tvel.durability = 100;
			}
		}
		
		
		public function turnOff(e:*=null):void
		{
			(_model.curElement[0] as TurbineDataModel).turnedOn = false;
			checkGenerators();
			_model.update();
		}

		public function turnOn(e:*=null):void
		{
			(_model.curElement[0] as TurbineDataModel).turnedOn = true;
			checkGenerators();
			_model.update();
		}
		
		public function changeTurbine(e:*=null):void
		{
			turnOff();
			(_model.curElement[0] as TurbineDataModel).repairing = 1;
		}
		
		public function setMoveTo(targ:Number):void
		{
			if (targ < 0) targ = 0;
			if (targ > 1000) targ = 1000;
			
			for each(var rod:RodDataModel in _model.curElement)
				rod.movingTo = targ;
			
			_model.update();
		}
		
		public function setCooling(cool:Number):void
		{
			_model.cooling = cool/4/6;
		}

		
		
		public function update():void
		{
			//TODO: send data to server
			
			/* ??????????
			if(curElementType == "S" && Key.isDown(Key.ENTER)){
				setMoveTo(Number(controlPanel.targetText.text));
			}*/
			
			checkGenerators();
			
			/* WTF ?????
			keyboardTimer += 1;
			
			//trace(Key.getAscii());
			
			for(var i = 0; i < 10; i++){
				if(Key.isDown(i+48)){
					if(lastKey != i){
						lastKey = i;
						_root.controlPanel.targetText.text += i;
					}
				}else if(lastKey == i){
					lastKey = -1;
				}
			}
			if(Key.isDown(Key.SPACE) && keyboardTimer > 3){//стереть значение целиком
				keyboardTimer = 0;
				_root.controlPanel.targetText.text = "";
			}
			if(Key.isDown(Key.BACKSPACE) && keyboardTimer > 3){//стереть последнее значение
				keyboardTimer = 0;
				_root.controlPanel.targetText.text = _root.controlPanel.targetText.text.substr(0,_root.controlPanel.targetText.length-1);
			}
			*/
			
			/**/
			for (var i:int = 0; i < _model.curElement.length; i++ ) 
			{
				if (_model.curElement[i] is ReactorElementDataModel)
				{
					_model.curElement[i].deep += _model.mC;
					
					if (_model.curElement[i].deep > 1000)
					{
						_model.curElement[i].deep = 1000;
						_model.curElement[i].movingTo = -1;
					}
					else if (_model.curElement[i].deep < 0)
					{
						_model.curElement[i].deep = 0;
						_model.curElement[i].movingTo = -1;
					}
				}
			}
			
			
			/* WTF ????
			if(oneStep == true){
				oneStep = false;
				mC = 0;
			}*/
			
			
			
			for each (var rod:RodDataModel in _model.rods){
				
				if (rod.movingTo >= 0)
				{
					if (Math.abs(rod.deep - rod.movingTo) < _model.ms)
					{
						rod.deep = rod.movingTo;
						rod.movingTo = -1;
					}
					else if (rod.deep < rod.movingTo)
					{
						rod.deep += _model.ms;
					}
					else if (rod.deep > rod.movingTo)
					{
						rod.deep -= _model.ms;
					}
				}
			}
			
			
			
			// ??????????????????????????????????????????//
			_model.eSumm = 0;
			_model.XeSumm = 0;
			
			
			
			var tvel:TvelDataModel
			for each(tvel in _model.tvels)
			{
				tvel.er = 0;
			}
			
		
			
			//////////////////////// first stand ////////////////////////////
			//Cc.log('_model.tvels.length='+_model.tvels.length)
			for (i = 0; i < _model.tvels.length; i++)//each(tvel in _model.tvels)
			{		
				tvel = _model.tvels[i];
				
				
				
				if (tvel.pulling)
				{
					tvel.deep-= 2;
				}
				else if (tvel.pushing && _model.t1 < 400) 
				{
					tvel.deep += 2;
				}
					
				if (tvel.deep <= 0)
				{
					tvel.pulling = false;
					tvel.deep = 0;
				}
				else if (tvel.deep >= 100)
				{
					tvel.pushing = false;
					tvel.deep = 100;
				}
				
				
				
				//for (var j:int = i + 1; j < 12; j++) {
				if (i < _model.rodDependencies.length) {
					
				//	Cc.log(_model.rodDependencies[i].length)
					
				for (var j:int =0; j < _model.rodDependencies[i].length; j++) {
					
					var dependRod:RodDataModel = _model.rodDependencies[i][j]
				//	Cc.log(dependRod+','+dependRod.deep+'  i='+i+'  j='+j);
					
					
					var deep:Number = dependRod.deep;
					
					
					var tvel2:TvelDataModel = _model.tvels[dependRod.dependency.position];
					
					if(deep || deep == 0){
						var kc:Number = 1;
						
						
						tvel.durability < 10 ? kc *= tvel.durability * 0.09 : kc *= 0.9+(tvel.durability-10)/900;
						tvel2.durability < 10 ? kc *= tvel2.durability*0.09 : kc *= 0.9+(tvel2.durability-10)/900;
						
						var er:Number = (tvel.deep/100) * (tvel2.deep/100) * (tvel.e[j]) * kc * dependRod.k*(1-deep*deep/(1000*1000))*1.0;
						er += (tvel.deep/100) * tvel.durability/500;
						er += (tvel2.deep/100) * tvel2.durability/500;
						
						tvel.er += er;
						tvel2.er += er;
						
						if(tvel.er + _model.t1*10>40000){
							dependRod.movingTo = 1000;
							burnTVEL(tvel, (tvel.er + _model.t1*10-40000));
						}
						if(tvel2.er + _model.t1*10>40000){
							dependRod.movingTo = 1000;
							burnTVEL(tvel2, (tvel2.er + _model.t1*10-40000));
						}
						tvel.durability	 -= er/_model.eMax;
						tvel2.durability -= er / _model.eMax;
						
						// glow gfx
						//showK[i][j].line._alpha = 15*Math.log(er);//Math.sqrt(er);
						
						
						var eTotal:Number = er*_model.kd;
						_model.Q1 += eTotal
						
						tvel.Tl[j]	 += er / 2 * _model.kU;
						tvel2.Tl[i]	 += er / 2 * _model.kU;
						
						var dTl:Number = tvel.Tl[j]*_model.kTl;
						tvel.Tl[j] -= dTl;
						var dI:Number = tvel.I[j] * _model.kI;
						tvel.I[j] += dTl - dI;
						var dXe:Number = tvel.Xe[j] * _model.kXe;
						tvel.Xe[j] += dI - dXe;
						
						dTl = tvel2.Tl[i] * _model.kTl;
						tvel2.Tl[i] -= dTl;
						dI = tvel2.I[i] * _model.kI;
						tvel2.I[i] += dTl - dI;
						dXe = tvel2.Xe[i]*_model.kXe;
						tvel2.Xe[i] += dI - dXe;
						
						var dXeSi:Number = tvel.Xe[j] * _model.kXeS;
						var dXeSj:Number = tvel2.Xe[i] * _model.kXeS;
						
						if(dXeSi+dXeSj > eTotal){
							dXeSi = dXeSi*eTotal/(dXeSi+dXeSj);
							dXeSj = dXeSj*eTotal/(dXeSi+dXeSj);
						}
						tvel2.Xe[i] -= dXeSi;
						tvel.Xe[j] -= dXeSj;
						
						dependRod.I = tvel.I[j]+tvel2.I[i];
						dependRod.Xe = tvel.Xe[j]+tvel2.Xe[i];
						
						dependRod.XeIntencity = .1 * Math.log(tvel2.Xe[i]);
						
						tvel2.e[i] = tvel.e[j] = eTotal-dXeSi-dXeSj;
						if(eTotal-dXeSi-dXeSj < 0){
							tvel2.e[i] = tvel.e[j] = 0;
						}
						
						dependRod.e = tvel.e[j];
						if(dependRod.e > _model.eCrit){
							
							tvel.pulling = true;
							tvel2.pulling = true;
							dependRod.movingTo = 1000;
						}
						_model.eSumm += dependRod.e;
						_model.XeSumm += dependRod.Xe;
					}
				
					}
				}
			}
		
			
			
			
			var dq:Number = (_model.t1 - _model.t2) * _model.kt12;
			_model.Q1 -= dq;
			_model.Q2 += dq;
			
			dq = (_model.t2 - _model.t3) * _model.kt23;
			_model.Q2 -= dq;
			
			//TODO: WTF cooling?
			_model.Q2 *= 1 - _model.cooling * _model.kohl;
			
			
			if(_model.t1 > 2000){
				
				_model.Q2 *= 1 - (_model.t2-2000)*_model.kohl2;
				/* freeze text display
				soundCooling.start();
				freeze2Text.text = "Ой, как не хорошо!";//"ВСЕМ ПИЗДА!!!";
				*/
			}/*else{
				ohlTextTimer = 0;
				freeze2Text.text = "";
			}*/
			
			_model.Q3 += dq;
			
			dq = (_model.t3 - _model.t4) * _model.kt34;
			_model.Q3 -= dq;
			_model.Q4 += dq;
			
			dq = (_model.t4 - _model.t5) * _model.kt45;
			_model.Q4 -= dq;
			_model.Q5 += dq;
			
			_model.t1 = _model.Q1 / (_model.v1 * _model.c1);
			_model.t2 = _model.Q2 / (_model.v2 * _model.c2);
			_model.t3 = _model.Q3 / (_model.v3 * _model.c3);
			_model.t4 = _model.Q4 / (_model.v4 * _model.c4);
			_model.t5 = _model.Q5 / (_model.v5 * _model.c5);
			
			_model.ms = 4*(_model.t1+2000)/2000;
			
			
			
			
			if(_model.t1 > 2000){
				/* freze indicator display
				freeze3Text._visible = true;
				*/
				for each (tvel in _model.tvels){
					tvel.pulling = true;
				}
			}/*else{
				freeze3Text._visible = false;
			}*/
			
			_model._globalB = 0;
			
			if(_model.t3 > 100) 	_model.p1 += (_model.t3-100)*_model.kSteam;
			if(_model.lockOpened) 	_model.p1 = 0;
			
			// TODO: Check this formula
			var Mturb:Number = _model.p1*_model.kMom/_model.generatorActive;
			
			for each(var turbine:TurbineDataModel in _model.turbines)
			{
				
				if (turbine.durability > 0)
				{
					_model.p1 -= turbine.vRotor * _model.kRotor;
					_model._globalB += turbine.vRotor * _model.kGeneration;
					turbine.B = turbine.vRotor * _model.kGeneration;
					
					turbine.durability -= 0.1 * (turbine.vRotor / _model.kIznKv + 1) * _model.kIzn * turbine.vRotor / 5;
					turbine.vRotor *= 0.9;
					
					//выработка энергии и трение, отрисовка
					if (turbine.turnedOn)
					{
						//воздействие момента
						if(Mturb-_model.MStart > 0 || turbine.vRotor > 0) {
							turbine.vRotor += (Mturb - _model.MFriction) / _model.kInertion;
						}
					}
				}
			}
			
			_model.totalEnergy += _model._globalB / 30;
			_model.update();
		}
		
	}
}

