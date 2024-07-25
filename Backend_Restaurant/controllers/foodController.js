const Food=require('../models/Food');

module.exports = {
 addFood: async (req, res) => {
    const {title,time,foodTags,category,code,restaurant,description,price,additives,imageUrl} = req.body;
    if(!title || !foodTags || !time || !category || !code || !restaurant || !description || !price || !additives || !imageUrl)
        {
            return res.status(400).json({status: false, message: 'You have a missing field'});
        }
   try {
     const newFood = new Food(req.body);
     await newFood.save();
     res.status(201).json({ status: true, message: "Food has been  successfully added"});

   } catch (err) {
    res.status(500).json({ status:false, message: err.message});
   } 
},

getFoodById: async (req,res) => {
  const id=req.params.id;
   try{
      const food = await Food.findById(id);

      res.status(200).json(food);
   }catch(error){
    res.status(500).json({status: false, message: error.message});
   }
},

  getRandomFood: async (req,res) =>{
    try{
         let randomFoodList=[];
         //check if code is provided in the params
         if(req.params.code){
            randomFoodList= await Food.aggregate(
            [
                {$match: {code: req.params.code}},
                { $sample: { size:3}},
                { $project: {__v: 0}}
            ]
        );
        }
     // if no code provided in params or no Foods match 
     if(!randomFoodList.length){
        randomFoodList= await Food.aggregate(
        [
            { $sample: { size:5}},
            { $project: {__v: 0}}
        ]
    );
    }

    //Respond with the result
        if(randomFoodList.length)
            {
                res.status(200).json(randomFoodList);
            }
           else{
            res.status(404).json({status:false,message:'No Foods found'});
           }
    }catch(error){
        res.status(500).json(error);
    }
  },

  getAllFoodsByCode:async(req,res) =>{
      const code = req.params.code;

      try{
        const foodList = await Food.find({code:code});

        return res.status(200).json(foodList);
      }catch(error){
        return res.status(500).json({status:false, error:error.message});  
    }
  },
  //Restaurant Menu
  getFoodsByRestaurant: async (req,res) => {
    const id =req.params.id;
    try {
        // Find foods by restaurant ID
        const foods = await Food.find({ restaurant: id });
        // Return the foods
        res.status(200).json(foods);
      } catch (error) {
        // Handle any errors that occurred during the database query
        res.status(500).json({ status: false, message: error.message });
      }
    },
  

getFoodsCategoryAndCode: async (req,res) =>{
  const {category,code}= req.params;
  try {
    const foods= await Food.aggregate([
        {$match: {category: category,code:code, isAvailable:true}},
        {$project: {__v:0}}
    ]);

    if(foods.length == 0){
        return res.status(200).json([]);
    }

    res.status(200).json(foods);
  }catch(error){
    res.status(500).json({status: false, message: error.message});
  }
},

searchFoods: async (req, res) => {
    const search = req.params.search;

    try {
        const result = await Food.find({
            $text: {
                $search: search
            }
        });
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
},



 getRandomFoodsByCategoryAndCode: async (req,res) => {
     const {category,code} = req.params;
     try{
        let foods;

        foods = await Food.aggregate([
            {$match: {category: category,code:code, isAvailable:true}},
            { $sample: { size:10}},
        ])

        if(!foods || foods.length == 0){
            foods =await Food.aggregate([
                {$match: {code:code, isAvailable:true}},
                { $sample: { size:10}},
            ])
        }else if(!foods || foods.length == 0){
            foods =await Food.aggregate([
                {$match: { isAvailable:true}},
                { $sample: { size:10}},
            ])
        }
         res.status(200).json(foods);
     }
     catch(error){
        res.status(500).json({status: false, message: error.message});
     }
 },
};