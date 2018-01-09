class CreatureLevelsController < ApplicationController

  def show
    render 'main'
  end

  def create
    user_input = params.require(:stats).permit(:hp,:ac,:str,:dex,:con,:int,:wis,:cha)

    formatted_data = []

    # Convert the parameter datatype to an array so it can be fed to the classifier
    formatted_data.push(user_input["hp"].strip.to_i)
    formatted_data.push(user_input["ac"].strip.to_i)
    formatted_data.push(user_input["str"].strip.to_i)
    formatted_data.push(user_input["dex"].strip.to_i)
    formatted_data.push(user_input["con"].strip.to_i)
    formatted_data.push(user_input["int"].strip.to_i)
    formatted_data.push(user_input["wis"].strip.to_i)
    formatted_data.push(user_input["cha"].strip.to_i)



    dec_tree = train() # Grab the trained classifer

    decision = dec_tree.predict(formatted_data) # Determine what the CR of the monster is
    puts "Predicted: #{decision}";

  end

  def train
    training_file = File.read("app\\assets\\json\\monsters.json") # Load JSON file full of Monster Data


    attributes = ['HP','AC','STR','DEX','CON',"INT","WIS","CHA"]
    training_data = []

    # Convert JSON file of monster data into something that our classifier can interpret
    JSON.parse(training_file).each do |f|
      # Strip the listings of text
      hp = f["hp"][0..2].strip.to_i
      ac = f["ac"][0..1].strip.to_i
      training_data.push( [ hp, ac, f["str"].strip.to_i, f["dex"].strip.to_i, f["con"].strip.to_i, f["int"].strip.to_i, f["wis"].strip.to_i, f["cha"].strip.to_i ] )
    end


    # Create and train the decision tree
    dec_tree = DecisionTree::ID3Tree.new(attributes, training_data, "Error", :discrete)
    dec_tree.train

    # Return the trained tree
    return dec_tree



  end

end
