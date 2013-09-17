class Parse
  def extract_library_paths(stdout)
    if stdout.empty?
      return []
    end 

    libraries = stdout.lines.to_a.map { |line| clean_library_path(line) }
    libraries = libraries.uniq
    libraries = libraries.reject { |library| nil == library }

    return libraries unless libraries.empty?

    return nil
  end

  def clean_library_path(path)
    if path.empty? || path.match(/[\/\.\w]+ \(.*\)$/) == nil
      return nil
    end
    
    cleanedPath = path.strip.sub(/ \(.*\)/, '')

    if cleanedPath.start_with?('/usr/lib')
      cleanedPath = nil
    end

    return cleanedPath

  end

  def extract_libraries(base_library, stdout)
    libraries = extract_library_paths(stdout)

    libraries = libraries.map { |path| {:binary_name => base_library.scan(/(([a-z]*)(.[0-9]*.dylib)?)$/)[0][0], :binary_path => base_library.strip, :dependency_name => path.scan(/(([a-z]*)(.[0-9]*.dylib)?)$/)[0][0], :dependency_path => path}}

    return libraries


  end
end