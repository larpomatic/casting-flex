package Model.ToolBox
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ToolBox
	 * Le package ToolBox contient l'ensemble des fonctions
	 * utilisables un peu partout dans le projet
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - MathTools.as
	 * Classe qui contient plusieus fonctions de calcul mathematique
	 *****************************************************/
	
	import DataObjects.Skill;
	
	import Model.DataManager.DataManager;
	
	import Views.ComputeCastingView;
	
	import mx.collections.ArrayCollection;
	
	public class MathTools
	{
		public function MathTools()
		{
		}
		
		/**
		 * Fonction qui calcule la moyenne arithmétique d'une liste de nombre
		 * @author Riyad YAKINE
		 * @since 2011/05/10
		 * @param Array Notre liste de nombres
		 * @return Number La moyenne
		 * */
		public static function mean(numberArray:ArrayCollection):Number
		{
			var locSum:Number = 0.0;
			var locArraySize:int = numberArray.length;
			var locMean:Number = 0.0;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{			
				for (var i:int = 0; i < locArraySize; i++)
				{
					locSum += numberArray[i];	
				}
				
				locMean = locSum/locArraySize;
				return (locMean)
			}
		}
		
		/**
		 * Fonction qui calcule la moyenne arithmétique d'une liste de nombre avec Pondération
		 * @author Mickael LEBON
		 * @since 2011/04/30
		 * @param Array Notre liste de nombres
		 * @return Number La moyenne
		 * */
		public static function meanWithPonderation(numberArray:ArrayCollection):Number
		{
			var locSum:Number = 0.0;
			var locArraySize:int = numberArray.length;
			var locMean:Number = 0.0;
			var locDiv:int = 0;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{
				for (var i:int = 0; i < locArraySize; ++i)
				{
					locSum += (numberArray[i] * ((DataManager.getInstance().skillsCastingArray[i] as Skill).ponderation));
					locDiv += ((DataManager.getInstance().skillsCastingArray[i] as Skill).ponderation);
				}
				locMean = locSum/locDiv;
				
				return (locMean)
			}
		}
		
		/**
		 * Fonction qui calcule la moyenne arithmétique d'une liste de nombre
		 * en éliminant les nombres négatifs
		 * @author Riyad YAKINE
		 * @since 2011/05/13
		 * @param Array Notre liste de nombres
		 * @return Number La moyenne sur les nombre positifs ou nul
		 * */
		public static function positiveMean(numberArray:ArrayCollection):Number
		{
			var locSum:Number = 0.0;
			var locArraySize:int = numberArray.length;
			var locMean:Number = 0.0;
			var locPositiveNumber:int = 0;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{
				for (var i:int = 0; i < locArraySize; i++)
				{
					if (numberArray[i] >= 0){
						locSum += numberArray[i];
						locPositiveNumber++;
					}
				}
				if (locPositiveNumber >= 1){
					locMean = locSum /locPositiveNumber;
				} else {
					locMean = locSum;
				}
				return (locMean)
			}
		}
		
		/**
		 * Fonction qui calcule la somme d'une liste de nombre
		 * @author Riyad YAKINE
		 * @since 2011/07/06
		 * @param Array Notre liste de nombres
		 * @return Number La somme
		 * */
		public static function sum(numberArray:Array):Number
		{
			var locSum:Number = 0.0;
			var locArraySize:int = numberArray.length;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{
				for (var i:int = 0; i < locArraySize; i++)
				{
					locSum += numberArray[i];	
				}
				return (locSum)
			}
		}
		
		/**
		 * Fonction qui calcule l'écart-type d'une liste de nombre
		 * @author Riyad YAKINE
		 * @since 2011/05/10
		 * @param Array Notre liste de nombres
		 * @return Number L'écart-type
		 * */
		public static function stdDev(numberArray:ArrayCollection):Number
		{
			var locSum:Number = 0.0;
			var locMean:Number = mean(numberArray);
			var locArraySize:int = numberArray.length;
			var locStdDev:Number = 0.0;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{
				for (var i:int = 0; i < locArraySize; i++)
				{
					var tmp:int = numberArray[i] - locMean;
					locSum = locSum + tmp * tmp;
				}
				if (locArraySize <= 1)
				{
					locStdDev = Math.sqrt(locSum / 1)
				}
				else
				{
					locStdDev = Math.sqrt(locSum / (locArraySize - 1))
				}
				
				return locStdDev;
			}
		}
		
		/**
		 * Fonction qui calcule l'écart-type d'une liste de nombre positif
		 * @author Riyad YAKINE
		 * @since 2011/05/10
		 * @param Array Notre liste de nombres
		 * @return Number L'écart-type
		 * */
		public static function positiveStdDev(numberArray:ArrayCollection):Number
		{
			var locSum:Number = 0.0;
			var locMean:Number = mean(numberArray);
			var locArraySize:int = numberArray.length;
			var locStdDev:Number = 0.0;
			var locPositiveNumber:int = 0;
			
			if (locArraySize <= 0)
			{
				return 0.0;
			}
			else
			{
				for (var i:int = 0; i < locArraySize; i++)
				{
					if (numberArray[i] > 0){
						var tmp:int = numberArray[i] - locMean;
						locSum = locSum + tmp * tmp;
						locPositiveNumber++;
					}
				}
				if (locPositiveNumber <= 1)
				{
					locStdDev = Math.sqrt(locSum / 1)
				}
				else
				{
					locStdDev = Math.sqrt(locSum / (locPositiveNumber - 1))
				}
				
				return locStdDev;
			}
		}
		
		/**
		 * Fonction qui renvoi le plus grand nombre entre deux nombres
		 * @author Riyad YAKINE
		 * @since 2011/10/04
		 * @param Number Notre  premier nombre
		 * @param Number Notre second nombre
		 * @return Number Le plus grand nombre
		 * */
		public static function max(parFirstInt:Number, parSecondInt:Number):Number
		{
			if (parFirstInt < parSecondInt)
				return parSecondInt;
			else
				return parFirstInt;
		}
		
		/**
		 * Fonction qui renvoi le plus grand nombre parmi une liste de nombre
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 * @param ArrayCollection Notre liste de nombre
		 * @return Number Le plus grand nombre
		 * */
		public static function maxInArray(parNumberArray:ArrayCollection):Number
		{
			var locMax:Number = 0.0;
			var locArraySize:int = parNumberArray.length;
			
			for (var i:int = 0; i < locArraySize; i++)
				locMax = max(locMax,parNumberArray[i]);
			return locMax;
		}
		
		/**
		 * Fonction qui calcule la factorielle d'un nombre
		 * @author Riyad YAKINE
		 * @since 2011/10/04
		 * @param Int Notre nombre dont on cherche la factorielle
		 * @return Number La factorielle de ce nombre (en number car potentiellement grand)
		 * */
		public static function fact(parInt:int):Number
		{
			var locRes:Number = 1;
			
			while (parInt > 1)
			{
				locRes = locRes * parInt;
				parInt = parInt - 1;
			}
			return locRes;
		}
		
		/**
		 * Fonction qui calcule l'arrangement combinatoire pour un ensemble
		 * A(k parmi n) = n! / (n - k)! avec k <= n
		 * Fourni le nombre d'ordonnancement possible des k parmi n
		 * @author Riyad YAKINE
		 * @since 2011/10/04
		 * @param Int Le sous ensemble "K"
		 * @param Int L'ensemble "N"
		 * @return Int L'arrangement "A"
		 * @see http://fr.wikipedia.org/wiki/Arrangement
		 * */
		public static function permutation(parKInt:int, parNInt:int):int
		{
			return (fact(parNInt)/fact(parNInt-parKInt));	
		}
		
	}
}