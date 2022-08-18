clear;
tree = xmlread('IES_TM_27_20_Example.spdx');
content = parseChildNodes(tree);

function children = parseChildNodes(theNode)
    % Recurse over node children.
    children = [];
    if theNode.hasChildNodes
        childNodes = theNode.getChildNodes;
        numChildNodes = childNodes.getLength;
        allocCell = cell(1, numChildNodes);

        children = struct(             ...
            'Name', allocCell, 'Attributes', allocCell,    ...
            'Data', allocCell, 'Children', allocCell);

        for count = 1:numChildNodes
            theChild = childNodes.item(count-1);
            children(count) = makeStructFromNode(theChild);
        end
    end
end

    % ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
    % Create structure of node info.

    nodeStruct = struct(                        ...
        'Name', char(theNode.getNodeName),       ...
        'Attributes', parseAttributes(theNode),  ...
        'Data', '',                              ...
        'Children', parseChildNodes(theNode));

    if any(strcmp(methods(theNode), 'getData'))
        nodeStruct.Data = char(theNode.getData);
    else
        nodeStruct.Data = '';
    end
end
    % ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
    % Create attributes structure.

    attributes = [];
    if theNode.hasAttributes
        theAttributes = theNode.getAttributes;
        numAttributes = theAttributes.getLength;
        allocCell = cell(1, numAttributes);
        attributes = struct('Name', allocCell, 'Value', ...
            allocCell);

        for count = 1:numAttributes
            attrib = theAttributes.item(count-1);
            attributes(count).Name = char(attrib.getName);
            attributes(count).Value = char(attrib.getValue);
        end
    end
end