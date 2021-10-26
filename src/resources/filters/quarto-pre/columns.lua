-- columns.lua
-- Copyright (C) 2021 by RStudio, PBC

function columns() 
  
  return {
  
    Div = function(el)  
      -- Process column classes on divs
      if el.attr.classes:includes('cell') then

        -- read the classes that should be forwarded
        local columnClasses = el.attr.classes:filter(isColumnClass)
        if #columnClasses > 0 then 
          -- Note that we are using columns
          preState.hasColumns = true

          -- Forward the column classes to figures
          for i, childEl in ipairs(el.content) do 
            if childEl.attr ~= undefined and childEl.attr.classes:includes('cell-output-display') then
              -- look through the children for any figures
              for j, figEl in ipairs(childEl.content) do
                local figure = discoverFigure(figEl, true)
                  if figure ~= nil then
                    tappend(figure.attr.classes, columnClasses)
                  end
              end
            end
          end
  
        end         
      end
      return el      
    end,

    Para = function(el) 
      if el.attr ~= undefined then
        local columnClasses = el.attr.classes:filter(isColumnClass)
        if #columnClasses > 0 then
            -- Note that we are using columns
            preState.hasColumns = true
        end
        end
    end
  }
end

function isColumnClass(clz) 
  if clz == undefined then
    return false
  else
    return clz:match('^column%-')
  end
end