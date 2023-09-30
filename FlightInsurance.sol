// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FlightInsurance {

    enum FlightStatus{
        OnTime,
        Delayed,
        Cancelled
    }
    FlightStatus public status;

    struct Passengerdetails {
        string Name;
        uint Age;
        uint Basefare;
        uint Conveniencefee;
        uint TicketPrice;
        uint InsuranceAmount;
       
    }

    struct Flightdetails {

        uint flightNumber;
        string departurefrom;
        string destination;
        uint departuretime;
        uint arrivaltime;
        uint revisedDeparture;
    }

    Passengerdetails public passengerdetail;
    Flightdetails public flightdetail;
    
    uint contractBalance;
    mapping(uint=>Passengerdetails) public passengerRegistry;
    mapping (uint =>Flightdetails ) public flight;
    uint ticketId = 1;
    uint flightId = 1;

    uint time= 1689175800;
    


    
    address immutable Admin;

    constructor() 
    {
        Admin = msg.sender;
       
    }

    function SpiceAirlines (
        uint _Id, 
        string memory _departurefrom, 
        string memory _destination, 
        uint _departuretime, 
        uint _arrivaltime) public onlyAdmin {

        flightdetail.flightNumber = _Id;
        flightdetail.departurefrom = _departurefrom;
        flightdetail.destination = _destination;
        flightdetail.departuretime = _departuretime;
        flightdetail.arrivaltime = _arrivaltime;

        flight[flightId] = flightdetail;
        flightId++;

        

    }

    function bookTicket (
    
        string memory _name, 
        uint _age, 
        uint _basefare, 
        uint _conveniencefee,
        uint _ticketprice, 
         uint _insuranceamount) public payable {

             require(msg.sender != Admin, "You are not allowed to book tickets");
             require(msg.value== _ticketprice , "insufficient amount");
        
        // Passengerdetails memory passengerdetail;
        passengerdetail.Name = _name;
        passengerdetail.Age = _age;
        passengerdetail.Basefare = _basefare;
        passengerdetail.Conveniencefee= _conveniencefee;
        passengerdetail.TicketPrice = _ticketprice;
        passengerdetail.InsuranceAmount = _insuranceamount;

        _ticketprice = 10000 wei;

        passengerRegistry[ticketId] = passengerdetail;
        ticketId++;

        

}

    modifier onlyAdmin() {
        require(msg.sender== Admin);
        _;
     }


    function Status () public onlyAdmin {
        time = flightdetail.departuretime - flightdetail.revisedDeparture;
        if(time >1689175800){status = FlightStatus.Delayed;}
        else if (time >1689175800) {status = FlightStatus.Cancelled;}
        else if (time <= 1689175800) {status = FlightStatus.OnTime;}

    }

    function claimInsusrance(address payable to) public {
        require(Admin !=msg.sender,"Admin can't claim insurance");
        require(status==FlightStatus.Delayed || status == FlightStatus.Cancelled, "Not eligible for the claim");
        to.transfer(passengerdetail.InsuranceAmount);
    }

    function sendBalance (address payable _to) public onlyAdmin payable {

        _to.transfer(msg.value);
    }

    function getBalance() public view returns(uint) {

        return address(this).balance;
    }


}
