class Opts::Parser < OptionParser
  property options : Array(Array(String)) = Array(Array(String)).new

  def to_s(io : IO)
    if banner = @banner
      io << banner
      io << "\n"
    end
    io << Pretty.lines(options, indent: "  ", delimiter: "  ")
  end

  private def append_flag(flag, description)
    options << [flag, description]
  end
end
