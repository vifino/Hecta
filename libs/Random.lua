function Random()
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
end
