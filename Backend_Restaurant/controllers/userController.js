const User = require('../models/User');
const jwt=require('jsonwebtoken');

module.exports = {
    getUser:async(req,res)=> {
        try{
            const user=await User.findById(req.user.id);

            const {password,__v,createdAt,...userData} = user._doc;

            res.status(200).json(userData);
        }catch(error){
           res.status(500).json({status:false,message:error.message});
        }
    },

    verifyAccount: async (req, res) => {
        const userOtp = req.params.otp;
        try {
            // Find the user by ID
            const user = await User.findById(req.user.id);
            
            // Check if user exists
            if (!user) {
                return res.status(400).json({ status: false, message: "User not found" });
            }
    
            // Check if the provided OTP matches the user's OTP
            if (userOtp == user.otp) {
                // Update verification status and reset OTP
                user.verification = true;
                user.otp = "none";
                
                // Save the updated user
                await user.save();
    
                const userToken=jwt.sign({
                    id: user._id,
                    userType: user.userType,
                    email: user.email,
                },process.env.JWT_SECRET, {expiresIn: "21d"});
                // Destructure user object to exclude sensitive fields
                const { password, __v, otp, createdAt, ...others } = user._doc;
                
                // Return the updated user data
                res.status(200).json({ ...others, userToken });
            } else {
                // Return error for invalid OTP
                return res.status(400).json({ status: false, message: "Invalid OTP" });
            }
        } catch (error) {
            // Return server error
            res.status(500).json({ status: false, message: error.message });
        }
    },
    
     verifyPhone:async (req, res) => {
        const phone = req.params.phone;
    
        try {
            // Assuming req.user.id is a valid ObjectId
            const user = await User.findOne({ _id: req.user.id });
    
            if (!user) {
                return res.status(400).json({ status: false, message: "User not found" });
            }
    
            user.phoneVerification = true;
            user.phone = phone;
    
            await user.save();
    
            const userToken = jwt.sign({
                id: user._id,
                userType: user.userType,
                email: user.email,
            }, process.env.JWT_SECRET, { expiresIn: "21d" });
    
            // Destructure user object to exclude sensitive fields
            const { password, __v, otp, createdAt, ...others } = user._doc;
    
            // Return the updated user data along with the token
            res.status(200).json({ ...others, userToken });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    deleteUser:async(req,res)=> {
        try{
          await User.findByIdAndDelete(req.user.id);
            res.status(200).json({status:true,message: "User deleted successfully"});
        }catch(error){
           res.status(500).json({status:false,message:error.message});
        }
    },
}