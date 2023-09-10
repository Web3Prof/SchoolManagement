import { assert } from "chai";
import { ethers } from "hardhat";
import { SchoolManagement } from "../typechain-types/SchoolManagement";

describe("School Management Basic Test", function(){
    let factory: any;
    let schoolManagement: SchoolManagement;

    beforeEach( async function(){
        const [owner] = await ethers.getSigners();
        factory = await ethers.getContractFactory("SchoolManagement",{
            signer: owner
        });
        console.log(owner);
        schoolManagement = await factory.deploy();
        
    })

    it("Deploy success", async function(){
        console.log("Address: ", await schoolManagement.getAddress());
        assert.isOk(await schoolManagement.getAddress());
    })

    it("Register teacher", async function(){
        const [, addr1] = await ethers.getSigners();
        console.log(addr1);
        const txn = await schoolManagement.connect(addr1).register("Bob", 1);
        const allTeachers = await schoolManagement.getAllTeachers();

        assert.equal(allTeachers[0][2], "Bob");
    })
}
)