require './lib/copypasta/parse'

describe "parse" do

  before :each do
    @parse = Parse.new
    @base_lib               = "  /usr/bin/lorem"
    @system_lib_1           = "  /usr/lib/libexpat.1.dylib (compatibility version 7.0.0, current version 7.2.0)"
    @custom_lib_1           = "   /usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib (compatibility version 5.0.0, current version 5.0.0)"
    @custom_lib_2           = "    /usr/local/Cellar/graphviz/2.32.0/lib/lorem.4.dylib (compatibility version 5.0.0, current version 5.0.0)"
    @lib_without_extension  = "   /usr/bin/foundation.framework/versions/A/FoundationLibrary"
  end

  it "should be init correctly" do
    @parse.should be_an_instance_of Parse
  end

  describe "clean_library_path" do
    describe "given empty data to clean" do
      it "should return nil" do
        result = @parse.clean_library_path("")
        result.should be_nil
      end
    end

    describe "given an invalid line" do
      it "should return nil" do
        result = @parse.clean_library_path("lorem ipsum")
        result.should be_nil
      end
    end

    describe "given only system data to clean" do
      it "should return nil" do
        result = @parse.clean_library_path(@system_lib_1)
        result.should be_nil
      end
    end  

    describe "given only a custom library to clean" do
      it "should return a cleaned path" do
        result = @parse.clean_library_path(@custom_lib_1)
        result.should_not be_nil
        result.should eq "/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib"
      end
    end  


    describe "given only a library without extension to clean" do
      it "should return a cleaned path" do
        result = @parse.clean_library_path(@lib_without_extension)
        result.should_not be_nil
        result.should eq "/usr/bin/foundation.framework/versions/A/FoundationLibrary"
      end
    end  
  end

  describe "clean_library_name" do
    describe "given only system data to clean" do
      it "should return nil" do
        result = @parse.clean_library_name(@system_lib_1)
        result.should be_nil
      end
    end  

    describe "given only a custom library to clean" do
      it "should return a cleaned name" do
        result = @parse.clean_library_name(@custom_lib_1)
        result.should_not be_nil
        result.should eq "libpathplan.4.dylib"
      end
    end

    describe "given only a library without extension to clean" do
      it "should return a cleaned name" do
        result = @parse.clean_library_name(@lib_without_extension)
        result.should_not be_nil
        result.should eq "FoundationLibrary"
      end
    end
  end

  describe "extract_library_paths" do
    describe "given a partial path" do
      it "should return nil" do
        libraryPaths = ["/usr/local/bin/dot:"].join("\n")
        result = @parse.extract_library_paths(libraryPaths)
        result.should be_nil
      end
    end

    describe "given 2 custom libraries and a system library" do
      it "should return 2 cleaned custom libraries" do
        libraryPaths = [@custom_lib_1, @system_lib_1, @custom_lib_2].join("\n")
        result = @parse.extract_library_paths(libraryPaths)
        result.should_not be_nil
        result.should be_an_instance_of Array
        result.length.should eq 2
        result[0].should eq "/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib"
        result[1].should eq "/usr/local/Cellar/graphviz/2.32.0/lib/lorem.4.dylib"
      end
    end

    describe "given 2 identical custom libraries" do
      it "should return only 1 cleaned custom libraries" do
        libraryPaths = [@custom_lib_1, @custom_lib_1].join("\n")
        result = @parse.extract_library_paths(libraryPaths)
        result.should_not be_nil
        result.should be_an_instance_of Array
        result.length.should eq 1
        result[0].should eq "/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib"
      end
    end
  end

  describe "extract_libraries" do
    describe "given a custom library" do
      it "should return an object with name and path properties" do
        libraryPaths = [@custom_lib_1, @custom_lib_1].join("\n")
        result = @parse.extract_libraries(@base_lib, libraryPaths)
        result.should_not be_nil
        result.length.should eq 1
        result[0].should have_key(:binary_path)
        result[0].should have_key(:binary_name)
        result[0].should have_key(:dependency_path)
        result[0].should have_key(:dependency_name)
        result[0][:binary_path].should eq "/usr/bin/lorem"
        result[0][:binary_name].should eq "lorem"
        result[0][:dependency_path].should eq "/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib"
        result[0][:dependency_name].should == "libpathplan.4.dylib"
      end
    end
  end

  describe "extract_libraries" do
    describe "given a custom library without extension" do
      it "should return an object with name and path properties" do
        libraryPaths = [@lib_without_extension].join("\n")
        result = @parse.extract_libraries(@base_lib, libraryPaths)
        result.should_not be_nil
        result.length.should eq 1
        result[0].should have_key(:binary_path)
        result[0].should have_key(:binary_name)
        result[0].should have_key(:dependency_path)
        result[0].should have_key(:dependency_name)
        result[0][:binary_path].should eq "/usr/bin/lorem"
        result[0][:binary_name].should eq "lorem"
        result[0][:dependency_path].should eq "/usr/bin/foundation.framework/versions/A/FoundationLibrary"
        result[0][:dependency_name].should == "FoundationLibrary"
      end
    end
  end
end