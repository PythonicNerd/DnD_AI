class CreatureLevelsController < ApplicationController

  def show
    render 'main'
  end

  def create
    user_input = params.require(:stats).permit(:hp,:ac,:str,:dex,:con,:int,:wis,:cha)
    formatted_data = []


    formatted_data.push(user_input["hp"])
    formatted_data.push(user_input["ac"])
    formatted_data.push(user_input["str"])
    formatted_data.push(user_input["dex"])
    formatted_data.push(user_input["con"])
    formatted_data.push(user_input["int"])
    formatted_data.push(user_input["wis"])
    formatted_data.push(user_input["cha"])

    formatted_data.push("1")


    #start training classifier

    training_file = File.read("app\\assets\\json\\monsters.json") # Load JSON file full of Monster Data


    attributes = ['HP','AC','STR','DEX','CON',"INT","WIS","CHA"]
    training_data = []


    JSON.parse(training_file).each do |f|
      hp = f["hp"][0..2]
      ac = f["hp"][0..1]

      training_data.push( [ hp, ac, f["str"], f["dex"], f["con"], f["int"], f["wis"], f["cha"] ] )

    end



      File.write("app\\assets\\json\\test1.txt", training_data)

      tree = DecisionTree::ID3Tree.new(['HP','AC','STR','DEX','CON',"INT","WIS","CHA"], training_data, "Elephant", :discrete)
      dec_tree = DecisionTree::ID3Tree.new(attributes, training_data, "Elephant", :discrete)
      dec_tree.train


  #  classifier = train()

    #decision = tree.predict(formatted_data)
    test = ["59", "12", "18", "15", "16", "2", "13", "8"]

  decision = dec_tree.predict(test)
  puts "Predicted: #{decision} ... True decision: #{test.last}";

  end

  #def train




  #end
end
