//Created By Mike Lodder
//Parser code modified from VHDL-AMS.

grammar vhdl;

options {
	k=3;
	language='CSharp';
}

tokens {
	ABS='abs';
	ACCESS='access';
	ACROSS='across';
	AFTER='after';
	ALIAS='alias';
	ALL='all';
	AND='and';
	ARCHITECTURE='architecture';
	ARRAY='array';
	ASSERT='assert';
	ATTRIBUTE='attribute';
	BEGIN='begin';
	BLOCK='block';
	BODY='body';
	BREAK='break';
	BUFFER='buffer';
	BUS='bus';
	CASE='case';
	COMPONENT='component';
	CONFIGURATION='configuration';
	CONSTANT='constant';
	DISCONNECT='disconnect';
	DOWNTO='downto';
	END='end';
	ENTITY='entity';
	ELSE='else';
	ELSIF='elsif';
	EXIT='exit';
	FILE='file';
	FOR='for';
	FUNCTION='function';
	GENERATE='generate';
	GENERIC='generic';
	GROUP='group';
	GUARDED='guarded';
	IF='if';
	IMPURE='impure';
	IN='in';
	INERTIAL='inertial';
	INOUT='inout';
	IS='is';
	LABEL='label';
	LIBRARY='library';
	LIMIT='limit';
	LINKAGE='linkage';
	LITERAL='literal';
	LOOP='loop';
	MAP='map';
	MOD='mod';
	NAND='nand';
	NATURE='nature';
	NEW='new';
	NEXT='next';
	NOISE='noise';
	NOR='nor';
	NOT='not';
	NULL='null';
	OF='of';
	ON='on';
	OPEN='open';
	OR='or';
	OTHERS='others';
	OUT='out';
	PACKAGE='package';
	PORT='port';
	POSTPONED='postponed';
	PROCESS='process';
	PROCEDURE='procedure';
	PROCEDURAL='procedural';
	PURE='pure';
	QUANTITY='quantity';
	RANGE='range';
	REJECT='reject';
	REM='rem';
	RECORD='record';
	REFERENCE='reference';
	REGISTER='register';
	REPORT='report';
	RETURN='return';
	ROL='rol';
	ROR='ror';
	SELECT='select';
	SEVERITY='severity';
	SHARED='shared';
	SIGNAL='signal';
	SLA='sla';
	SLL='sll';
	SPECTRUM='spectrum';
	SRA='sra';
	SRL='srl';
	SUBNATURE='subnature';
	SUBTYPE='subtype';
	TERMINAL='terminal';
	THEN='then';
	THROUGH='through';
	TO='to';
	TOLERANCE='tolerance';
	TRANSPORT='transport';
	TYPE='type';
	UNAFFECTED='unaffected';
	UNITS='units';
	UNTIL='until';
	USE='use';
	VARIABLE='variable';
	WAIT='wait';
	WITH='with';
	WHEN='when';
	WHILE='while';
	XNOR='xnor';
	XOR='xor';
}
//------------------------------------------Parser----------------------------------------
abstract_literal
   :  DECIMAL_LITERAL
   |  BASE_LITERAL
   ;

access_type_definition
  : ACCESS subtype_indication
  ;

across_aspect
  : identifier_list ( tolerance_aspect )? ( VARASGN expression )? ACROSS
  ;

actual_designator
  : expression
  | OPEN
  ;

actual_parameter_part
  : association_list
  ;

actual_part
  : (name LPAREN)=> name LPAREN actual_designator RPAREN
  | actual_designator
  ;

adding_operator
  : PLUS
  | MINUS
  | AMPERSAND
  ;

aggregate
  : LPAREN element_association ( COMMA element_association )* RPAREN
  ;

alias_declaration
  : ALIAS alias_designator ( COLON alias_indication )? IS
    name ( signature )? SEMI
  ;

alias_designator
  : identifier
  | CHARACTER_LITERAL
  | STRING_LITERAL
  ;

alias_indication
  : (subnature_indication)=> subnature_indication
  | subtype_indication
  ;

allocator
  : NEW ( (name CHARACTER_LITERAL)=> qualified_expression | subtype_indication )
  ;

architecture_body
  : ARCHITECTURE identifier OF name IS
    architecture_declarative_part
    BEGIN
    architecture_statement_part
    END ( ARCHITECTURE )? ( identifier )? SEMI
  ;

architecture_declarative_part
  : ( block_declarative_item )*
  ;

architecture_statement
  : block_statement
  | (( label_colon )? ( POSTPONED )? PROCESS)=>
    process_statement
  | (( label_colon )? ( POSTPONED )? procedure_call SEMI)=>
    concurrent_procedure_call_statement
  | (( label_colon )? ( POSTPONED )? ASSERT)=>
    concurrent_assertion_statement
  | (( label_colon )? ( POSTPONED )?
      ( conditional_signal_assignment | selected_signal_assignment ))=>
    concurrent_signal_assignment_statement
  | (label_colon instantiated_unit)=>
    component_instantiation_statement
  | (label_colon generation_scheme GENERATE)=>
    generate_statement
  | (( label_colon )? BREAK ( break_list )? ( sensitivity_clause )?)=>
    concurrent_break_statement
  | simultaneous_statement
  ;

architecture_statement_part
  : ( architecture_statement )*
  ;

array_nature_definition
  : (ARRAY LPAREN index_subtype_definition)=> unconstrained_nature_definition
  | constrained_nature_definition
  ;

array_type_definition
  : (unconstrained_array_definition)=> unconstrained_array_definition
  | constrained_array_definition
  ;

assertion
  : ASSERT condition ( REPORT expression )? ( SEVERITY expression )?
  ;

assertion_statement
  : ( label_colon )? assertion SEMI
  ;

association_element
  : ( (formal_part ARROW)=> formal_part ARROW )? actual_part
  ;

association_list
  : association_element ( COMMA association_element )*
  ;

attribute_declaration
  : ATTRIBUTE label_colon name SEMI
  ;

// Need to add several tokens here, for they are both, VHDLAMS reserved words
// and attribute names.
// (25.2.2004, e.f.)
attribute_designator
  : identifier
  | RANGE
  | ACROSS
  | THROUGH
  | REFERENCE
  | TOLERANCE
  ;

attribute_specification
  : ATTRIBUTE attribute_designator OF entity_specification IS expression SEMI
  ;

base_unit_declaration
  : identifier SEMI
  ;

binding_indication
  : ( USE entity_aspect )? ( generic_map_aspect )? ( port_map_aspect )?
  ;

block_configuration
  : FOR block_specification
    ( use_clause )*
    ( configuration_item )*
    END FOR SEMI
  ;

block_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | signal_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | component_declaration
  | attribute_declaration
  | attribute_specification
  | configuration_specification
  | disconnection_specification
  | step_limit_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  | nature_declaration
  | subnature_declaration
  | quantity_declaration
  | terminal_declaration
  ;

block_declarative_part
  : ( block_declarative_item )*
  ;

block_header
  : ( generic_clause ( generic_map_aspect SEMI )? )?
    ( port_clause ( port_map_aspect SEMI )? )?
  ;

block_specification
  : (identifier)=> identifier ( LPAREN index_specification RPAREN )?
  | name
  ;

block_statement
  : label_colon BLOCK ( LPAREN expression RPAREN )? ( IS )?
    block_header
    block_declarative_part BEGIN
    block_statement_part 
    END BLOCK ( identifier )? SEMI
  ;

block_statement_part
  : ( architecture_statement )*
  ;

branch_quantity_declaration
  : QUANTITY ( (across_aspect)=> across_aspect )?
    ( through_aspect )? terminal_aspect SEMI
  ;

break_element
  : ( break_selector_clause )? name ARROW expression
  ;

break_list
  : break_element ( COMMA break_element )*
  ;

break_selector_clause
  : FOR name USE
  ;

break_statement
  : ( label_colon )? BREAK ( break_list )? ( WHEN condition )? SEMI
  ;

case_statement
  : ( label_colon )? CASE expression IS
    ( case_statement_alternative )+
    END CASE ( identifier )? SEMI
  ;

case_statement_alternative
  : WHEN choices ARROW sequence_of_statements
  ;

choice
  : (identifier)=> identifier
  | (discrete_range)=> discrete_range
  | simple_expression
  | OTHERS
  ;

choices
  : choice ( BAR choice )*
  ;

component_configuration
  : FOR component_specification
    ( binding_indication SEMI )?
    ( block_configuration )?
    END FOR SEMI
  ;

component_declaration
  : COMPONENT identifier ( IS )?
    ( generic_clause )?
    ( port_clause )?
    END COMPONENT ( identifier )? SEMI
  ;

component_instantiation_statement
  : label_colon instantiated_unit
    ( generic_map_aspect )?
    ( port_map_aspect )? SEMI
  ;

component_specification
  : instantiation_list COLON name
  ;

composite_nature_definition
  : array_nature_definition
  | record_nature_definition
  ;

composite_type_definition
  : array_type_definition
  | record_type_definition
  ;

concurrent_assertion_statement
  : ( label_colon )? ( POSTPONED )? assertion SEMI
  ;

concurrent_break_statement
  : ( label_colon )? BREAK ( break_list )? ( sensitivity_clause )?
    ( WHEN condition )? SEMI
  ;

concurrent_procedure_call_statement
  : ( label_colon )? ( POSTPONED )? procedure_call SEMI
  ;

concurrent_signal_assignment_statement
  : ( label_colon )? ( POSTPONED )?
    ( conditional_signal_assignment | selected_signal_assignment )
  ;

condition
  : expression
  ;

condition_clause
  : UNTIL condition
  ;

conditional_signal_assignment
  : target LE opts conditional_waveforms SEMI
  ;

conditional_waveforms
  : waveform ( (WHEN condition ELSE)=> conditional_waveforms_bi )?
    ( WHEN condition )?
  ;
conditional_waveforms_bi
  : WHEN condition ELSE waveform
    ( (WHEN condition ELSE)=> conditional_waveforms_bi )?
  ;

configuration_declaration
  : CONFIGURATION identifier OF name IS
    configuration_declarative_part
    block_configuration
    END ( CONFIGURATION )? ( identifier )? SEMI
  ;

configuration_declarative_item
  : use_clause
  | attribute_specification
  | group_declaration
  ;

configuration_declarative_part
  : ( configuration_declarative_item )*
  ;

configuration_item
  : block_configuration
  | component_configuration
  ;

configuration_specification
  : FOR component_specification binding_indication SEMI
  ;

constant_declaration
  : CONSTANT identifier_list COLON subtype_indication
    ( VARASGN expression )? SEMI
  ;

constrained_array_definition
  : ARRAY index_constraint OF subtype_indication
  ;

constrained_nature_definition
  : ARRAY index_constraint OF subnature_indication
  ;

constraint
  : range_constraint
  | index_constraint
  ;

context_clause
  : ( context_item )*
  ;

context_item
  : library_clause
  | use_clause
  ;

delay_mechanism
  : TRANSPORT
  | ( REJECT expression )? INERTIAL
  ;

design_file
  : ( design_unit )* EOF
  ;

design_unit
  : context_clause library_unit
  ;

designator
  : identifier
  | STRING_LITERAL
  ;

direction
  : TO
  | DOWNTO
  ;

disconnection_specification
  : DISCONNECT guarded_signal_specification AFTER expression SEMI
  ;

discrete_range
  : (range)=> range
  | subtype_indication
  ;

element_association
  : ( (choices ARROW)=> choices ARROW )? expression
  ;

element_declaration
  : identifier_list COLON element_subtype_definition SEMI
  ;

element_subnature_definition
  : subnature_indication
  ;

element_subtype_definition
  : subtype_indication
  ;

entity_aspect
  : ENTITY name ( LPAREN identifier RPAREN )?
  | CONFIGURATION name
  | OPEN
  ;

entity_class
  : ENTITY
  | ARCHITECTURE
  | CONFIGURATION
  | PROCEDURE
  | FUNCTION
  | PACKAGE
  | TYPE
  | SUBTYPE
  | CONSTANT
  | SIGNAL
  | VARIABLE
  | COMPONENT
  | LABEL
  | LITERAL
  | UNITS
  | GROUP
  | FILE
  | NATURE
  | SUBNATURE
  | QUANTITY
  | TERMINAL
  ;

entity_class_entry
  : entity_class ( BOX )?
  ;

entity_class_entry_list
  : entity_class_entry ( COMMA entity_class_entry )*
  ;

entity_declaration
  : ENTITY identifier IS entity_header
    entity_declarative_part
    ( BEGIN entity_statement_part )?
    END ( ENTITY )? ( identifier )? SEMI
  ;

entity_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | signal_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | attribute_declaration
  | attribute_specification
  | disconnection_specification
  | step_limit_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  | nature_declaration
  | subnature_declaration
  | quantity_declaration
  | terminal_declaration
  ;

entity_declarative_part
  : ( entity_declarative_item )*
  ;

entity_designator
  : entity_tag ( signature )?
  ;

entity_header
  : ( generic_clause )?
    ( port_clause )?
  ;

entity_name_list
  : entity_designator ( COMMA entity_designator )*
  | OTHERS
  | ALL
  ;

entity_specification
  : entity_name_list COLON entity_class
  ;

entity_statement
  : (( label_colon )? ( POSTPONED )? ASSERT)=> concurrent_assertion_statement
  | (( label_colon )? ( POSTPONED )? PROCESS)=> process_statement
  | concurrent_procedure_call_statement
  ;

entity_statement_part
  : ( entity_statement )*
  ;

entity_tag
  : identifier
  | CHARACTER_LITERAL
  | STRING_LITERAL
  ;

enumeration_literal
  : identifier
  | CHARACTER_LITERAL
  ;

enumeration_type_definition
  : LPAREN enumeration_literal ( COMMA enumeration_literal )* RPAREN
  ;

exit_statement
  : ( label_colon )? EXIT ( identifier )? ( WHEN condition )? SEMI
  ;

// NOTE that NAND/NOR are in (...)* now (used to be in (...)?).
// (21.1.2004, e.f.)
expression
  : relation ( options{greedy=true;}: logical_operator relation )*
  ;

factor
  : primary ( options{greedy=true;}: DOUBLESTAR primary )?
  | ABS primary
  | NOT primary
  ;

file_declaration
  : FILE identifier_list COLON subtype_indication
    ( file_open_information )? SEMI
  ;

file_logical_name
  : expression
  ;

file_open_information
  : ( OPEN expression )? IS file_logical_name
  ;

file_type_definition
  : FILE OF name
  ;

formal_parameter_list
  : interface_list
  ;

formal_part
  : name ( LPAREN  name RPAREN )?
  ;

free_quantity_declaration
  : QUANTITY identifier_list COLON subtype_indication
    ( VARASGN expression )? SEMI
  ;

function_call
  : name ( LPAREN actual_parameter_part RPAREN )?
  ;

generate_statement
  : label_colon generation_scheme
    GENERATE
    ( ( block_declarative_item )* BEGIN )?
    ( architecture_statement )*
    END GENERATE ( identifier )? SEMI
  ;

generation_scheme
  : FOR parameter_specification
  | IF condition
  ;

generic_clause
  : GENERIC LPAREN generic_list RPAREN SEMI
  ;

generic_list
  : interface_list
  ;

generic_map_aspect
  : GENERIC MAP LPAREN association_list RPAREN
  ;

group_constituent
  : name
  | CHARACTER_LITERAL
  ;

group_constituent_list
  : group_constituent ( COMMA group_constituent )*
  ;

group_declaration
  : GROUP label_colon name
    LPAREN group_constituent_list RPAREN SEMI
  ;

group_template_declaration
  : GROUP identifier IS LPAREN entity_class_entry_list RPAREN SEMI
  ;

guarded_signal_specification
  : signal_list COLON name
  ;

identifier
  : BASIC_IDENTIFIER
  | EXTENDED_IDENTIFIER
  ;

identifier_list
  : identifier ( COMMA identifier )*
  ;

if_statement
  : ( label_colon )? IF condition THEN
    sequence_of_statements
    ( ELSIF condition THEN sequence_of_statements )* 
    ( ELSE sequence_of_statements )?
    END IF ( identifier )? SEMI
  ;

index_constraint
  : LPAREN discrete_range ( COMMA discrete_range )* RPAREN
  ;

index_specification
  : (discrete_range)=> discrete_range
  | expression
  ;

index_subtype_definition
  : name RANGE BOX
  ;

instantiated_unit
  : ( COMPONENT )? name
  | ENTITY name ( LPAREN identifier RPAREN )?
  | CONFIGURATION name
  ;

instantiation_list
  : identifier ( COMMA identifier )*
  | OTHERS
  | ALL
  ;

interface_constant_declaration
  : ( CONSTANT )? identifier_list COLON ( IN )? subtype_indication
    ( VARASGN expression )?
  ;

interface_declaration
  : (interface_constant_declaration)=> interface_constant_declaration
  | (interface_signal_declaration)=> interface_signal_declaration
  | interface_variable_declaration
  | interface_file_declaration
  | interface_terminal_declaration
  | interface_quantity_declaration
  ;

interface_element
  : interface_declaration
  ;

interface_file_declaration
  : FILE identifier_list COLON subtype_indication
  ;

interface_list
  : interface_element ( SEMI interface_element )*
  ;

interface_quantity_declaration
  : QUANTITY identifier_list COLON ( IN | OUT )? subtype_indication
    ( VARASGN expression )?
  ;

interface_signal_declaration
  : ( SIGNAL )? identifier_list COLON ( mode )? subtype_indication
    ( BUS )? ( VARASGN expression )?
  ;

interface_terminal_declaration
  : TERMINAL identifier_list COLON subnature_indication
  ;

interface_variable_declaration
  : ( VARIABLE )? identifier_list COLON
    ( mode )? subtype_indication ( VARASGN expression )?
  ;

iteration_scheme
  : WHILE condition
  | FOR parameter_specification
  ;

label_colon
  : identifier COLON
  ;

library_clause
  : LIBRARY logical_name_list SEMI
  ;

library_unit
  : ( ARCHITECTURE | PACKAGE BODY )=> secondary_unit
  | primary_unit
  ;

literal
  : NULL
  | BIT_STRING_LITERAL
  | (DBLQUOTE)=> STRING_LITERAL
  | (enumeration_literal)=> enumeration_literal
  | numeric_literal
  ;

logical_name
  : identifier
  ;

logical_name_list
  : logical_name ( COMMA logical_name )*
  ;

logical_operator
  : AND
  | OR
  | NAND
  | NOR
  | XOR
  | XNOR
  ;

loop_statement
  : ( label_colon )? ( iteration_scheme )?
    LOOP
    sequence_of_statements 
    END LOOP ( identifier )? SEMI
  ;

mode
  : IN
  | OUT
  | INOUT
  | BUFFER
  | LINKAGE
  ;

multiplying_operator
  : MUL
  | DIV
  | MOD
  | REM
  ;


// was
//   name
//     : simple_name
//     | operator_symbol
//     | selected_name
//     | indexed_name
//     | slice_name
//     | attribute_name
//     ;
// changed to avoid left-recursion to name (from selected_name, indexed_name,
// slice_name, and attribute_name, respectively)
// (2.2.2004, e.f.)
name
  : ( identifier | STRING_LITERAL )
    ( options{greedy=true;}:
      (
          DOT suffix
        | CHARACTER_LITERAL aggregate
        | ( signature )? CHARACTER_LITERAL attribute_designator
        | (LPAREN expression ( COMMA expression )* RPAREN)=>
            LPAREN expression ( COMMA expression )* RPAREN
        | (LPAREN actual_parameter_part RPAREN)=>
            LPAREN actual_parameter_part RPAREN
        | LPAREN discrete_range ( COMMA discrete_range )* RPAREN
      )
    )*
  ;

nature_declaration
  : NATURE identifier IS nature_definition SEMI
  ;

nature_definition
  : scalar_nature_definition
  | composite_nature_definition
  ;

nature_element_declaration
  : identifier_list COLON element_subnature_definition
  ;

next_statement
  : ( label_colon )? NEXT ( identifier )? ( WHEN condition )? SEMI
  ;

numeric_literal
  : (abstract_literal)=> abstract_literal
  | physical_literal
  ;

object_declaration
  : constant_declaration
  | signal_declaration
  | variable_declaration
  | file_declaration
  | terminal_declaration
  | quantity_declaration
  ;

opts
  : ( GUARDED )? ( delay_mechanism )?
  ;

package_body
  : PACKAGE BODY identifier IS
    package_body_declarative_part
    END ( PACKAGE BODY )? ( identifier )? SEMI
  ;

package_body_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | use_clause
  | group_template_declaration
  | group_declaration
  ;

package_body_declarative_part
  : ( package_body_declarative_item )*
  ;

package_declaration
  : PACKAGE identifier IS
    package_declarative_part
    END ( PACKAGE )? ( identifier )? SEMI
  ;

package_declarative_item
  : subprogram_declaration
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | signal_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | component_declaration
  | attribute_declaration
  | attribute_specification
  | disconnection_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  | nature_declaration
  | subnature_declaration
  | terminal_declaration
  ;

package_declarative_part
  : ( package_declarative_item )*
  ;

parameter_specification
  : identifier IN discrete_range
  ;

physical_literal
  : ( abstract_literal )? name
  ;

physical_type_definition
  : range_constraint UNITS base_unit_declaration
    ( secondary_unit_declaration )* 
    END UNITS ( identifier )?
  ;

port_clause
  : PORT LPAREN port_list RPAREN SEMI
  ;

port_list
  : interface_list
  ;

port_map_aspect
  : PORT MAP LPAREN association_list RPAREN
  ;

primary
  : (function_call)=> function_call
  | (name CHARACTER_LITERAL)=> qualified_expression
  | (LPAREN expression RPAREN)=> LPAREN expression RPAREN
  | literal
  | allocator
  | aggregate
  ;

primary_unit
  : entity_declaration
  | configuration_declaration
  | package_declaration
  ;

procedural_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | variable_declaration
  | alias_declaration
  | attribute_declaration
  | attribute_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  ;

procedural_declarative_part
  : ( procedural_declarative_item )*
  ;

procedural_statement_part
  : ( sequential_statement )*
  ;

procedure_call
  : name ( LPAREN actual_parameter_part RPAREN )?
  ;

procedure_call_statement
  : ( label_colon )? procedure_call SEMI
  ;

process_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | attribute_declaration
  | attribute_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  ;

process_declarative_part
  : ( process_declarative_item )*
  ;

process_statement
  : ( label_colon )? ( POSTPONED )? PROCESS
    ( LPAREN sensitivity_list RPAREN )? ( IS )?
    process_declarative_part
    BEGIN
    process_statement_part 
    END ( POSTPONED )? PROCESS ( identifier )? SEMI
  ;

process_statement_part
  : ( sequential_statement )*
  ;

qualified_expression
  : name CHARACTER_LITERAL ( (aggregate)=> aggregate | LPAREN expression RPAREN )
  ;

quantity_declaration
  : (free_quantity_declaration)=> free_quantity_declaration
  | (branch_quantity_declaration)=> branch_quantity_declaration
  | source_quantity_declaration
  ;

quantity_list
  : name ( COMMA name )*
  | OTHERS
  | ALL
  ;

quantity_specification
  : quantity_list COLON name
  ;

range
  : (simple_expression direction simple_expression)=>
    simple_expression direction simple_expression
  | name
  ;

range_constraint
  : RANGE range
  ;

record_nature_definition
  : RECORD ( nature_element_declaration )+
    END RECORD ( identifier )?
  ;

record_type_definition
  : RECORD ( element_declaration )+
    END RECORD ( identifier )?
  ;

relation
  : shift_expression
    ( options{greedy=true;}: relational_operator shift_expression )?
  ;

relational_operator
  : EQ
  | NEQ
  | LOWERTHAN
  | LE
  | GREATERTHAN
  | GE
  ;

report_statement
  : ( label_colon )? REPORT expression ( SEVERITY expression )? SEMI
  ;

return_statement
  : ( label_colon )? RETURN ( expression )? SEMI
  ;

scalar_nature_definition
  : name ACROSS name THROUGH name REFERENCE
  ;

scalar_type_definition
  : (range_constraint UNITS)=> physical_type_definition
  | enumeration_type_definition
  | range_constraint
  ;

secondary_unit
  : architecture_body
  | package_body
  ;

secondary_unit_declaration
  : identifier EQ physical_literal SEMI
  ;

selected_signal_assignment
  : WITH expression SELECT target LE opts selected_waveforms SEMI
  ;

selected_waveforms
  : waveform WHEN choices ( COMMA waveform WHEN choices )*
  ;

sensitivity_clause
  : ON sensitivity_list
  ;

sensitivity_list
  : name ( COMMA name )*
  ;

sequence_of_statements
  : ( sequential_statement )*
  ;

sequential_statement
  : (( label_colon )? WAIT)=> wait_statement
  | (( label_colon )? ASSERT)=> assertion_statement
  | (( label_colon )? REPORT)=> report_statement
  | (( label_colon )? target LE)=> signal_assignment_statement
  | (( label_colon )? target VARASGN)=> variable_assignment_statement
  | (( label_colon )? IF)=> if_statement
  | (( label_colon )? CASE)=> case_statement
  | (( label_colon )? ( iteration_scheme )? LOOP)=> loop_statement
  | (( label_colon )? NEXT)=> next_statement
  | (( label_colon )? EXIT)=> exit_statement
  | (( label_colon )? RETURN)=> return_statement
  | (( label_colon )? NULL SEMI)=> ( label_colon )? NULL SEMI
  | (( label_colon )? BREAK)=> break_statement
  | procedure_call_statement
  ;

shift_expression
  : simple_expression
    ( options{greedy=true;}: shift_operator simple_expression )?
  ;

shift_operator
  : SLL
  | SRL
  | SLA
  | SRA
  | ROL
  | ROR
  ;

signal_assignment_statement
  : ( label_colon )?
    target LE ( delay_mechanism )? waveform SEMI
  ;

signal_declaration
  : SIGNAL identifier_list COLON
    subtype_indication ( signal_kind )? ( VARASGN expression )? SEMI
  ;

signal_kind
  : REGISTER
  | BUS
  ;

signal_list
  : name ( COMMA name )*
  | OTHERS
  | ALL
  ;

signature
  : LBRACKET ( name ( COMMA name )* )? ( RETURN name )? RBRACKET
  ;

// NOTE that sign is applied to first operand only (LRM does not permit
// `a op -b' - use `a op (-b)' instead).
// (3.2.2004, e.f.)
simple_expression
  : ( PLUS | MINUS )? term ( options{greedy=true;}: adding_operator term )*
  ;

simple_simultaneous_statement
  : ( label_colon )?
    simple_expression ASSIGN simple_expression ( tolerance_aspect )? SEMI
  ;

simultaneous_alternative
  : WHEN choices ARROW simultaneous_statement_part
  ;

simultaneous_case_statement
  : ( label_colon )? CASE expression USE
    ( simultaneous_alternative )+ 
    END CASE ( identifier )? SEMI
  ;

simultaneous_if_statement
  : ( label_colon )? IF condition USE
    simultaneous_statement_part
    ( ELSIF condition USE simultaneous_statement_part )*
    ( ELSE simultaneous_statement_part )?
    END USE ( identifier )? SEMI
  ;

simultaneous_procedural_statement
  : ( label_colon )? PROCEDURAL ( IS )?
    procedural_declarative_part BEGIN
    procedural_statement_part 
    END PROCEDURAL ( identifier )? SEMI
  ;

simultaneous_statement
  : (( label_colon )? simple_expression ASSIGN)=> simple_simultaneous_statement
  | (( label_colon )? IF condition USE)=> simultaneous_if_statement
  | (( label_colon )? CASE expression USE)=> simultaneous_case_statement
  | (( label_colon )? PROCEDURAL ( IS )?)=> simultaneous_procedural_statement
  | ( label_colon )? NULL SEMI
  ;

simultaneous_statement_part
  : ( simultaneous_statement )*
  ;

source_aspect
  : SPECTRUM simple_expression COMMA simple_expression
  | NOISE simple_expression
  ;

source_quantity_declaration
  : QUANTITY identifier_list COLON subtype_indication source_aspect SEMI
  ;

step_limit_specification
  : LIMIT quantity_specification WITH expression SEMI
  ;

subnature_declaration
  : SUBNATURE identifier IS subnature_indication SEMI
  ;

subnature_indication
  : name ( index_constraint )? 
    ( TOLERANCE expression ACROSS expression THROUGH )?
  ;

subprogram_body
  : subprogram_specification IS
    subprogram_declarative_part
    BEGIN
    subprogram_statement_part
    END ( subprogram_kind )? ( designator )? SEMI
  ;

subprogram_declaration
  : subprogram_specification SEMI
  ;

subprogram_declarative_item
  : (subprogram_declaration)=> subprogram_declaration
  | subprogram_body
  | type_declaration
  | subtype_declaration
  | constant_declaration
  | variable_declaration
  | file_declaration
  | alias_declaration
  | attribute_declaration
  | attribute_specification
  | use_clause
  | group_template_declaration
  | group_declaration
  ;

subprogram_declarative_part
  : ( subprogram_declarative_item )*
  ;

subprogram_kind
  : PROCEDURE
  | FUNCTION
  ;

subprogram_specification
  : PROCEDURE designator ( LPAREN formal_parameter_list RPAREN )?
  | ( PURE | IMPURE )? FUNCTION designator
    ( LPAREN formal_parameter_list RPAREN )? RETURN name
  ;

subprogram_statement_part
  : ( sequential_statement )*
  ;

subtype_declaration
  : SUBTYPE identifier IS subtype_indication SEMI
  ;

// VHDLAMS 1076.1-1999 declares first name as optional. Here, second name
// is made optional to prevent antlr nondeterminism.
// (9.2.2004, e.f.)
subtype_indication
  : name ( name )? ( constraint )? ( (TOLERANCE)=> tolerance_aspect )?
  ;

suffix
  : identifier
  | CHARACTER_LITERAL
  | STRING_LITERAL
  | ALL
  ;

target
  : name
  | aggregate
  ;

term
  : factor ( options{greedy=true;}: multiplying_operator factor )*
  ;

terminal_aspect
  : name ( TO name )?
  ;

terminal_declaration
  : TERMINAL identifier_list COLON subnature_indication SEMI
  ;

through_aspect
  : identifier_list ( tolerance_aspect )? ( VARASGN expression )? THROUGH
  ;

timeout_clause
  : FOR expression
  ;

tolerance_aspect
  : TOLERANCE expression
  ;

type_declaration
  : TYPE identifier ( IS type_definition )? SEMI
  ;

type_definition
  : scalar_type_definition
  | composite_type_definition
  | access_type_definition
  | file_type_definition
  ;

unconstrained_array_definition
  : ARRAY LPAREN index_subtype_definition ( COMMA index_subtype_definition )*
    RPAREN OF subtype_indication
  ;

unconstrained_nature_definition
  : ARRAY LPAREN index_subtype_definition ( COMMA index_subtype_definition )*
    RPAREN OF subnature_indication
  ;

use_clause
  : USE name ( COMMA name )* SEMI
  ;

variable_assignment_statement
  : ( label_colon )? target VARASGN expression SEMI
  ;

variable_declaration
  : ( SHARED )? VARIABLE identifier_list COLON
    subtype_indication ( VARASGN expression )? SEMI
  ;

wait_statement
  : ( label_colon )? WAIT ( sensitivity_clause )? 
    ( condition_clause )? ( timeout_clause )? SEMI
  ;

waveform
  : waveform_element ( COMMA waveform_element )*
  | UNAFFECTED
  ;   

waveform_element
  : expression ( AFTER expression )?
  ;

//------------------------------------------Lexer-----------------------------------------
BASE_LITERAL
   :  ( '#' EXTENDED_DIGIT ( '.' EXTENDED_DIGIT )? '#' ( EXPONENT )? ) 
   {$setType(BASED_LITERAL);}
   ;
   
BIT_STRING_LITERAL
  : ( 'b' | 'o' | 'x' ) '\"' EXTENDED_DIGIT '\"'
  ;

DECIMAL_LITERAL
   :	INTEGER ( ( '.' INTEGER )? ( EXPONENT )? )
   ;

EXTENDED_DIGIT
   : INTEGER | LETTER
   ;
   
BASIC_IDENTIFIER
   :   LETTER ( '_' | LETTER | DIGIT )*
   ;
   
EXTENDED_IDENTIFIER
  : '\\' ( 'a'..'z' | '0'..'9' | '&' | '\'' | '(' | ')'
    | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '|'
    | ' ' | OTHER_SPECIAL_CHARACTER | '\\'
    | '#' | '[' | ']' | '_' )+ '\\'
  ;

BASE
  : INTEGER
  ;

BASE_SPECIFIER
  :  'B' | 'O' | 'X'
  ;

LETTER	
  :  'a'..'z' | 'A'..'Z'
  ;

COMMENT
  : '--' ( ~'\n' )* {$setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP);}
  ;

TAB
  : ( '\t' )+ {$setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP);}
  ;

SPACE
  : ( ' ' )+ {$setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP);}
  ;

NEWLINE
  : '\n' {$setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP); newline();}
  ;

CR
  : '\r' {$setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP);}
  ;
  
CHARACTER_LITERAL
   : '\'' .* '\''
   {$setType(CHARACTER_LITERAL);}
   ;

STRING_LITERAL
  : '\"' .* '\"'
  {$setType(STRING_LITERAL)}
  ;

OTHER_SPECIAL_CHARACTER
  : '!' | '$' | '%' | '@' | '?' | '^' | '`' | '{' | '}' | '~'
  | ' ' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  | '?' | '?' | '?' | '?' | '?' | '?' | '?' | '?'
  ;


DOUBLESTAR    : '**'  ;
ASSIGN        : '=='  ;
LE            : '<='  ;
GE            : '>='  ;
ARROW         : '=>'  ;
NEQ           : '/='  ;
VARASGN       : ':='  ;
BOX           : '<>'  ;
DBLQUOTE      : '\"'  ;
SEMI          : ';'   ;
COMMA         : ','   ;
AMPERSAND     : '&'   ;
LPAREN        : '('   ;
RPAREN        : ')'   ;
LBRACKET      : '['   ;
RBRACKET      : ']'   ;
COLON         : ':'   ;
MUL           : '*'   ;
DIV           : '/'   ;
PLUS          : '+'   ;
MINUS         : '-'   ;
LOWERTHAN     : '<'   ;
GREATERTHAN   : '>'   ;
EQ            : '='   ;
BAR           : '|'   ;
DOT           : '.'   ;
BACKSLASH     : '\\'  ;
  

EXPONENT
  :  'e' ( '+' | '-' )? INTEGER
  ;

HEXDIGIT
    :	('A'..'F'|'a'..'f')
    ;  

INTEGER
  :  DIGIT ( '_' | DIGIT )*
  ;
  
 DIGIT
  :  '0'..'9'
  ;
