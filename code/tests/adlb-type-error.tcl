# Copyright 2013 University of Chicago and Argonne National Laboratory
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# Test what happens if we try to get something of the wrong type

package require turbine 0.0.1
adlb::init 1 1

if [ adlb::amserver ] {
    adlb::server
} else {
    set d1 [ adlb::unique ]
    adlb::create $d1 $adlb::INTEGER 0
    adlb::store  $d1 $adlb::INTEGER 25
    set d2 [ adlb::unique ]
    adlb::create $d2 $adlb::INTEGER 0
    adlb::store  $d2 $adlb::INTEGER 26

    adlb::retrieve $d1 $adlb::INTEGER
    adlb::retrieve $d2 $adlb::STRING
}

adlb::finalize 1
puts OK

proc exit args {}
