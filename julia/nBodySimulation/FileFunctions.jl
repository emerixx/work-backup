using JSON
using DataStructures

function makeNBodyInitialConditionsFile(n)
  jsonContent = Dict()
  
  bodies = []
  for i in 1:n
    push!(bodies, Dict("$i" => Dict("mass"=>1,"position"=>[0.0, 0.0],"velocity"=>[0.0, 0.0])))
  end
    
  for i in 1:n
    jsonContent = merge(jsonContent, bodies[i])
      
  end
    
    
  

 
  compSettings = Dict("computationSettings" => Dict("timeStep"=>10^-4,"simulationTime"=>10^2))
  jsonContent = sort(collect(jsonContent), by=x->parse(Int, String(first(x))[1:end]))
    
    
  stringdata = JSON.json(jsonContent)
       
        
  # write the file with the stringdata variable information
    
  open("write_read.json", "w") do f
    write(f, stringdata)
  end
  
  
end

function readJsonFile()
  dict2 = JSON.parse(open("write_read.json"))
  for i in dict2
    
    for y in values(i)
      curBodyState = bodyState_s(0, [0,0], [0,0]);
      

      for (k, v) ∈ pairs(y)
        
        if k == "mass"
          curBodyState = bodyState_s(v, curBodyState.position, curBodyState.velocity)
        elseif k == "position"
          curBodyState = bodyState_s(curBodyState.mass, v, curBodyState.velocity)
        elseif k == "velocity"
          
          curBodyState = bodyState_s(curBodyState.mass, curBodyState.position, v)
          
        end
      end
      
      push!(currentBodiesState, curBodyState)
    end
  end 
  
end

function createOutputFiles()
  for i in range(1, NOfBodies)
    open("$(outputFolderLocation)/$i.txt", "w") do f
      write(f, "")
    end
    
  end
end
function writePositionsToFiles()
  
  for i in range(1, NOfBodies)
    
    open("$(outputFolderLocation)/$i.txt", "a") do f
      write(f, "$(currentBodiesState[i].position)\n")
    end
  end
end




