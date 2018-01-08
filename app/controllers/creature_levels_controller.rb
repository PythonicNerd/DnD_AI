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


    training_file = File.read("app\\assets\\json\\monsters.json") # Load JSON file full of Monster Data


    training_data = []
    attributes = ['HP','AC','STR','DEX','CON',"INT","WIS","CHA"]


    JSON.parse(training_file).each do |f|

      training_data.push( [ f["hp"], f["ac"], f["str"], f["dex"], f["con"], f["int"], f["wis"], f["cha"], f["cr"] ] )

      end

      puts training_data.length


      tree = DecisionTree::ID3Tree.new(attributes, training_data, "1", :discrete)
      tree.train


  #  classifier = train()

    #decision = tree.predict(formatted_data)
    decision = tree.predict(["12","22","213","12","34","53","125","32","1"])

    puts decision.class

    puts "8888888888888888888888"
    puts decision
    puts "8888888888888888888888"


  end

  #def train




  #end
end
