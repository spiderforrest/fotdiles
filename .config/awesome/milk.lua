local M = {}

M.name = "milk"

function M.arrange(p)
  -- set master location
  p.geometries[p.clients[1]] = {
    x = 970,
    y = 64,
    width = 1476,
    height = 837
  }

  -- set first slave
  if #p.clients > 1 then
    p.geometries[p.clients[2]] = {
      x = 20,
      y = 666,
      width = 707,
      height = 571
    }
  end

  -- set second slave
  if #p.clients > 2 then
    p.geometries[p.clients[3]] = {
      x = 1011,
      y = 1056,
      width = 1396,
      height = 285
    }
  end
end

return M
