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

# Flex ADLB/MPE in Tcl
# No real Turbine data flow here

# This may be used as a benchmark by setting
# TURBINE_TEST_PARAM_1 in the environment

package require turbine 1.0

namespace import turbine::string_*

turbine::defaults
turbine::init $servers

if { [ info exists env(TURBINE_TEST_PARAM_1) ] } {
    set iterations $env(TURBINE_TEST_PARAM_1)
} else {
    set iterations 4
}

# Define MPE events
set L [ mpe::create_pair "test_mpe-3" ]
set event_start [ lindex $L 0 ]
set event_end   [ lindex $L 1 ]

if { ! [ adlb::amserver ] } {

    set rank [ adlb::rank ]
    puts "rank: $rank"
    set workers [ adlb::workers ]
    if { $rank == 0 } {
	puts "iterations: $iterations"
        puts "events $event_start $event_end"
    }
    puts "workers:    $workers"

    for { set i 1 } { $i <= $iterations } { incr i } {

        mpe::log $event_start "start-loop-body"
        set id [ expr $rank + $i * ($workers + 1) ]
        adlb::create $id string
        adlb::store $id string "message rank:$rank:$i"

        # turbine::c::debug "get"
        set msg [ adlb::retrieve $id ]
        # turbine::c::debug "got: $msg"
        mpe::log $event_end "end-loop-body"
    }
} else {
    adlb::server
}

turbine::finalize
puts OK
