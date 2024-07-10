using JSON
using DataStructures

function makeNBodyInitialConditionsFile(n)
  jsonContent = Dict()
  
  bodies = []
  for i in 1:n
    push!(bodies, Dict("$i" => Dict("mass"=>1,"position"=>[0.0, 0.0],"velocity"=>[0.0, 0.0], "_acceleration"=>[0.0, 0.0])))
  end
    
  for i in 1:n
    jsonContent = merge(jsonContent, bodies[i])
      
  end
    
    
  

  if jsonContent != 0
    compSettings = Dict("computationSettings" => Dict("timeStep"=>10^-4,"simulationTime"=>10^2))
    jsonContent = sort(collect(jsonContent), by=x->parse(Int, String(first(x))[1:end]))
    
    
    stringdata = JSON.json(jsonContent)
       
        
    # write the file with the stringdata variable information
    
    open("write_read.json", "w") do f
      write(f, stringdata)
    end
    
  else 
    println("Error: Your code is fucked (makeNBodyInitialConditionsFile, jsonContent doesnt exist)")
  end

end

function readJsonFile()
  dict2 = JSON.parse(open("write_read.json"))
  for i in dict2
    
    for y in values(i)
      curBody = Body(0, [0,0], [0,0], [0,0]);
      
      for (k, v) ∈ pairs(y)
        
        if k == "mass"
          curBody = Body(v, curBody.position, curBody.velocity, curBody.acceleration)
        elseif k == "position"
          curBody = Body(curBody.mass, v, curBody.velocity, curBody.acceleration)
        elseif k == "velocity"
          curBody = Body(curBody.mass, curBody.position, v, curBody.acceleration)
        elseif k == "_acceleration"
          curBody = Body(curBody.mass, curBody.position, v, curBody.acceleration)
        end 
      end
      push!(bodies, curBody)
    end
  end 
  
end