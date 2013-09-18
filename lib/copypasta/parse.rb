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
    cleanedPath = path.strip

    if cleanedPath.empty? || !cleanedPath.start_with?('/')
      return nil
    end

#    if path.empty? || path.match(/[\/\.\w]+ \(.*\)$/) == nil
#     return nil
#    end
    
    cleanedPath = path.strip.sub(/ \(.*\)$/, '')

    if cleanedPath.start_with?('/usr/lib')
      return nil
    end

    if cleanedPath.match(/[a-z]+$/) == nil
      return nil
    end

    return cleanedPath

  end

  def clean_library_name(path)
    cleanedLibraryName = clean_library_path(path)

    cleanedLibraryName = cleanedLibraryName.scan(/([a-zA-z]*[a-zA-z0-9\.]*)$/)[0][0] unless cleanedLibraryName == nil

  end


  def extract_libraries(base_library, stdout)
    libraries = extract_library_paths(stdout)

    libraries = libraries.map { |path| {:binary_name => clean_library_name(base_library), :binary_path => base_library.strip, :dependency_name => clean_library_name(path), :dependency_path => path}}

    return libraries


  end
end