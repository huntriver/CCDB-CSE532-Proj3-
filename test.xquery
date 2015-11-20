xquery version "3.0";
declare default element namespace "http://localhost:8080/exist/CCDB";
declare function local:indirectuser($direct as element()*,$indirect as element()*) as element()*
{
    let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB
  let $t1:=

     
   for $d in $direct//direct,
      $i in $indirect//indirect,
      $c in $CCDB//Card
  where $d/CId=$c/CId
    and $c/Owner=$i/PId
  return 
      <indirect>
          {$d/PId}
          {$i/CId}
      </indirect>
     
     
 let $t2:=
   for $d in $direct//direct
   return 
      <indirect>
          {$d/PId}
          {$d/CId}
      </indirect>
   
   
   let $t4:=  <a>{$t1 union $t2}</a>
    
let $t3:=
 for $d in distinct-values($t4//indirect/PId),
    $c in distinct-values($t4//indirect[PId = $d]/CId)
return 
  <indirect>
          <PId>{$d}</PId>
          <CId>{$c}</CId>
      </indirect>
  
  return
    if (count($t3)>count($indirect//indirect))
      then
         local:indirectuser($direct,<indirectuser>{$t3}</indirectuser>)
     else
         $t3
      
        
};
let $CCDB := doc("/db/CCDB/CCDB.xml")/CCDB


let $authusers:=
       <authusers>
        {
            
            for 
              $p in $CCDB//Person,
                $c in $CCDB//Card,
                $a in $c//AuthorizedUser
      where $p/PId=$a
      return 
          <authuser>
              {$p/PId} {$c/CId}
  
  
              
          </authuser>
        }
    {
    for 
              $p in $CCDB//Person,
                $c in $CCDB//Card,
                $o in $CCDB//Organization,
                $s in $o//Signer
      where $p/PId=$s and
            $o/OId=$c/Owner
      return 
          <authuser>
              {$p/PId} {$c/CId}
  
  
              
          </authuser>
        }
  </authusers>
  
return
    <Query>
     <query1>
        {
            for $o in $CCDB//Organization,
              $p1 in $CCDB//Person,
              $p2 in $CCDB//Person,
              $c in $CCDB//Card,
              $s in $o//Signer,
              $a in $c//AuthorizedUser
      where ($c/Limit - $c/Balance<1000)
      and $c/Owner=$o/OId
      and $a=$p1/PId
      and $s=$p2/PId

      
      return 
          <result>
              <user>{$p1/PId} {$p1/PersonName}</user>
              <signer>{$p2/PId} {$p2/PersonName}</signer>
  
              
              
          </result>
        }
     </query1>
     <query2>
         {
            for $p in $CCDB//Person
                
            let $a:= $authusers//authuser[PId=$p/PId]  
            where count($p//OwnedCard)>=4
                  and count($a)>=3
            return
                <result>
              {$p/PId} {$p/PersonName}
              
  
              
              
          </result>
            
         }
    </query2>
 <query3>
         {
             let $pp:=
             <PersonWhoHasACardLimitsAbove25000>{
             for $p in $CCDB//Person
               let $cc:=
                   for $c1 in $p/OwnedCard
                   let $c2:= $CCDB//Card[CId=$c1]
                   where $c2/Limit>=25000
                   return $c1
               
                 where 
                  not (exists($cc))
                return 
                    $p
             }
             </PersonWhoHasACardLimitsAbove25000>
         
          let $oo:=
           <OrgsWhoHaveASignerInAboveSet>{
            for $o in $CCDB//Organization,
                $s in $o//Signer,
               $x in $pp//Person
              where $x/PId=$s
            return $o
           }
           </OrgsWhoHaveASignerInAboveSet>
           
           for 
               $o in $CCDB//Organization
            let $o2:=
               for  $o1 in $oo//Organization
               where
                $o1/OId=$o/OId
               return $o
              
           where not(exists($o2))
           return 
               for $c in $o/OwnedCard
               let $c2:=$CCDB//Card[CId=$c]
               return <result>
                   {$c2/CId}
                   </result>

               
            
         }
    </query3>
   <query4>
       {
        let $direct:=
        <directusers>
            {
            for $a in  $authusers//authuser
            return
               <direct>
                   {$a/PId}
                   {$a/CId}
            </direct>
            }
         </directusers>
                   
         let $indirect:=
         <indirectusers>{
            for $a in  $authusers//authuser
            return
               <indirect>
                   {$a/PId}
                   {$a/CId}
                   </indirect>
         }
         </indirectusers>
    let $res:=<res>{local:indirectuser($direct,$indirect)}</res>
     return  
         for $x in $res//indirect
         return
             <result>
                 {
                     $x/PId
                 }
                 {$x/CId}
                </result>
  
            
           
       }
   </query4>
   
   <query5>
       {
           let $direct:=
        <directusers>
            {
            for $a in  $authusers//authuser
            return
               <direct>
                   {$a/PId}
                   {$a/CId}
            </direct>
            }
         </directusers>
                   
         let $indirect:=
         <indirectusers>{
            for $a in  $authusers//authuser
            return
               <indirect>
                   {$a/PId}
                   {$a/CId}
                   </indirect>
         }
         </indirectusers>
        let $res:=<res>{local:indirectuser($direct,$indirect)}</res>
    
          
         let $bals:= for 
               $c in $CCDB//Card[CId=$res//indirect[PId=$CCDB//Person[PersonName="Joe"]/PId]/CId]
           return $c/Balance
       
       return <result>{sum($bals)}</result>
       }
       </query5>
  </Query>

  
