include image
import image as i

hanoi = [array: [array: 4, 3, 2, 1], [array: 0, 0, 0, 0], [array: 0, 0, 0, 0 ]]

forste-hull = hanoi.get-now(0)
andre-hull = hanoi.get-now(1)
tredje-hull = hanoi.get-now(2)


var trekk-teller = 0

var trekk-tabbel = table: trekk-nummer :: Number, sirkel :: String, hull :: String
end


fun finn-sirkel-farge(nummer :: Number) -> String:
  doc: "tar in sirkel nummer og gjør om til farge"
  ask:
    | nummer == 1 then: "rød"
    | nummer == 2 then: "grønn"
    | nummer == 3 then: "blå"
    | nummer == 4 then: "oransje"
  end
end

fun finn-hull-navn(hull :: Array) -> String:
  doc: "for bruk i tabbellen"
  ask:
    | hull == forste-hull then: "første hull"
    | hull == andre-hull then: "andre hull"
    | hull == tredje-hull then: "tredje hull"
  end
end

fun registrer-trekk(sirkel-nummer :: Number, hull :: Array):
  doc: "legger til en ny rad for siste trekken på tabbellen"
  block:
    trekk-teller := trekk-teller + 1
    row = trekk-tabbel.row(trekk-teller, finn-sirkel-farge(sirkel-nummer), finn-hull-navn(hull))
    trekk-tabbel := trekk-tabbel.add-row(row)
  end
end


fun finn-overst-sirkel-indeks(hull :: Array) -> Number:
  doc: "returnerer indeksen til øverst sirkel i hullen. returnerer -1 hvis hullen er tom"
  ask:
    | hull.get-now(3) == 1 then: 3
      
    | hull.get-now(2) == 1 then: 2
    | hull.get-now(2) == 2 then: 2
      
    | hull.get-now(1) == 1 then: 1
    | hull.get-now(1) == 2 then: 1
    | hull.get-now(1) == 3 then: 1
      
    | hull.get-now(0) == 1 then: 0
    | hull.get-now(0) == 2 then: 0
    | hull.get-now(0) == 3 then: 0
    | hull.get-now(0) == 4 then: 0
    | otherwise: -1
  end
end

fun flytt(fra-hull, til-hull): 
  doc: ```
      fra-hull = hullen vi skal flytte sirkel fra
      til-hull = hullen vi skal flytte sirkel til
      
      denne funksjonen finner øverst sirkelen i en hull og flytter den til den valgte hullen hvis det er mulig. 
       returnerer en error hvis det er ikke mulig
  ```
  block:
    overst-sirkel-indeks-fra = finn-overst-sirkel-indeks(fra-hull) # indeksen til øverst sirkel i hullen vi skal flytte fra
    when overst-sirkel-indeks-fra == -1:
      raise("du kan ikke flytte fra en tom hull.")
    end
    sirkel = fra-hull.get-now(overst-sirkel-indeks-fra)
    annen-sirkel = til-hull.get-now(0) # sirkel som ligger i hullen vi skal flytte til. 
    mulig = (annen-sirkel == 0) or ((annen-sirkel - sirkel) > 0)
    # for at vi kan flytte en sirkel til en hull må hullen være tom eller sirkelen som ligger der må være større enn den sirkelen vi skal flytte
    when not(mulig):
      raise("ikke mulig!")
     end
    
    var neste-hull-indeks = 0 # hvor i hullen vi skal putte sirkelen. default er 0 
    overst-sirkel-indeks-til = finn-overst-sirkel-indeks(til-hull) # øverst sirkel i hullen vi skal flytte til
    when not(overst-sirkel-indeks-til == -1): # hvis hullen er ikke tom
      neste-hull-indeks := overst-sirkel-indeks-til + 1 # øverst indeks som er ledig
    end

    til-hull.set-now(neste-hull-indeks, sirkel) 
    fra-hull.set-now(overst-sirkel-indeks-fra, 0) # slett sirkelen fra forrige hull
    
    registrer-trekk(sirkel, til-hull)
    
    
  end
  
end


gronn = i.circle(60,"solid", "green")
rod = i.circle(40,"solid", "red")
null = i.circle(0,"solid", "transparent") 
bla = i.circle(80,"solid","blue")
oransje = i.circle(100,"solid","orange")
bakgrunn = i.circle(100,"solid","transparent")


fun finn-sirkel-i(hull :: Array, indeks :: Number):
  doc: ```finner hvilken sirkel som ligger i spesiferte indeksen av spesifert hull. returnerer nul
       returnerer null hvis den er tom```
  ask:
    | hull.get-now(indeks) == 1 then: rod
    | hull.get-now(indeks) == 2 then: gronn
    | hull.get-now(indeks) == 3 then: bla
    | hull.get-now(indeks) == 4 then: oransje
    | otherwise: null
  end
end


fun tegn():
  doc: "tegner hanoi basert på arrayen."
  #beside baserer posisjonen på sirkler på hverandre
    beside(
      #overlay legger sirkler over hverandre
      overlay(i.circle(14,"solid","brown"),
        #nesting lar en overlaye flere sirkler
      overlay(finn-sirkel-i(forste-hull, 3),
        overlay(finn-sirkel-i(forste-hull, 2),
          overlay(finn-sirkel-i(forste-hull, 1),
            overlay(finn-sirkel-i(forste-hull, 0),
              bakgrunn))))),
    
    #nester beside for flere "pinner"
    beside(
      overlay(i.circle(14,"solid","brown"),
        overlay(finn-sirkel-i(andre-hull, 3),
          overlay(finn-sirkel-i(andre-hull, 2),
            overlay(finn-sirkel-i(andre-hull, 1),
              overlay(finn-sirkel-i(andre-hull, 0),
                bakgrunn))))),
    
     overlay(i.circle(14,"solid","brown"),
        overlay(finn-sirkel-i(tredje-hull, 3),
          overlay(finn-sirkel-i(tredje-hull, 2),
            overlay(finn-sirkel-i(tredje-hull, 1),
              overlay(finn-sirkel-i(tredje-hull, 0),
                bakgrunn)))))))
end


fun resultat() -> Table:
  block:
    print("total antall trekk: " + to-string(trekk-teller))
    trekk-tabbel
  end
end

fun se-om-vinner():
  summen-i-tredje-hull = tredje-hull.get-now(0) + tredje-hull.get-now(1) + tredje-hull.get-now(2) + tredje-hull.get-now(3)
  vant = summen-i-tredje-hull == 10
  vant
end

fun play-move(fra-hull, til-hull): 
  block:
    flytt(fra-hull, til-hull)
    
    vant = se-om-vinner()
    
    bilden = tegn()
    
    
    when vant:
      block:

        print("Du vant spillet!!")
        print("skriv resultat() for å se resultatene dine.")
        print("skriv restart() for å begynne nytt spill.")
      end
    end
    
    bilden # må være sist for at funksjonen skal returnere bildet
  end
end


fun tom-hull(hull):
  block:
  hull.set-now(0, 0)
  hull.set-now(1, 0)
  hull.set-now(2, 0)
  hull.set-now(3, 0)
  end
end

fun restart():
  doc: "starter spillet på nytt"
  block:
    forste-hull.set-now(0, 4)
    forste-hull.set-now(1, 3)
    forste-hull.set-now(2, 2)
    forste-hull.set-now(3, 1)
    tom-hull(andre-hull)
    tom-hull(tredje-hull)
    
    trekk-tabbel := trekk-tabbel.empty()
    trekk-teller := 0
    
    print("spillet er begynt på nytt!")
    tegn()
  end
end




d = ```Velkommen til Hanoi Tårnet 
for å flytte en disk, skriv play-move(<hull-navn>, <hull-navn>)
hull-navn kan være en av forste-hull, andre-hull, tredje-hull
EKSEMPEL: 
play-move(forste-hull, tredje-hull)
```
print(d)

tegn() # initiell tilstand 
