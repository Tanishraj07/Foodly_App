const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const CategoryRouter = require('./routes/category');
const RestaurantRoute=require('./routes/restaurant');
const FoodRoute = require('./routes/food');
const RatingRoute = require('./routes/rating');
const sendEmail=require('./utils/smtp_function');
const generateOtp=require('./utils/otp_generator');
const AuthRoute = require('./routes/auth');
const UserRoute = require('./routes/user');
const AddressRoute=require('./routes/address');
const CartRoute =require('./routes/cart');
const OrderRoute = require('./routes/order');
const cors = require('cors');


dotenv.config();


const app = express();
const port = process.env.PORT || 6013;

mongoose.connect(process.env.MONGOURL)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB...', err));

  app.use(cors());
  const otp=generateOtp();
  console.log(otp);

 

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/",AuthRoute);
app.use("/api/users",UserRoute);
app.use("/api/category", CategoryRouter);
app.use("/api/restaurant",RestaurantRoute);
app.use("/api/foods",FoodRoute);
app.use("/api/rating",RatingRoute);
app.use("/api/address",AddressRoute);
app.use("/api/cart",CartRoute);
app.use("/api/orders",OrderRoute);

app.listen(port, () => console.log(`Restaurant Backend is running on port ${port}!`));
