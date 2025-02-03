// SPDX-FileCopyrightText: © 2023 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
pragma solidity 0.8.26;

interface ERC20Like {
    function balanceOf(address) external returns (uint256);
    function approve(address usr, uint256 wad) external returns (bool);
}

interface JoinLike {
    function dai() external view returns (address);
    function usds() external view returns (address);
    function join(address, uint256) external;
}

contract DssBlow2 {
    address public immutable vow;
    ERC20Like public immutable dai;
    ERC20Like public immutable usds;
    JoinLike public immutable daiJoin;
    JoinLike public immutable usdsJoin;

    event Blow(address indexed token, uint256 amount);

    constructor(address daiJoin_, address usdsJoin_, address vow_) {
        daiJoin = JoinLike(daiJoin_);
        dai = ERC20Like(daiJoin.dai());
        usdsJoin = JoinLike(usdsJoin_);
        usds = ERC20Like(usdsJoin.usds());
        vow = vow_;
        dai.approve(daiJoin_, type(uint256).max);
        usds.approve(usdsJoin_, type(uint256).max);
    }

    function blow() public {
        uint256 daiBalance = dai.balanceOf(address(this));
        if (daiBalance > 0) {
           daiJoin.join(vow, daiBalance);
           emit Blow(address(dai), daiBalance);
        }
        uint256 usdsBalance = usds.balanceOf(address(this));
        if (usdsBalance > 0) {
            usdsJoin.join(vow, usdsBalance);
            emit Blow(address(usds), usdsBalance);
        }
    }
}
